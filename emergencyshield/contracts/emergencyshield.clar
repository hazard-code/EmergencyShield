;; EmergencyShield: Decentralized Disaster Relief Protocol
;; A transparent and fair disaster relief fund management system

;; Define NFT Trait
(define-trait nft-trait
    (
        (transfer (uint principal principal) (response bool uint))
        (get-owner (uint) (response principal uint))
        (get-last-token-id () (response uint uint))
        (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
    )
)

;; Constants
(define-constant emergency-admin tx-sender)
(define-constant min-donation-amount u100000)
(define-constant vote-threshold-percent u75)
(define-constant nft-metadata-uri "ipfs://emergencyshield/metadata/")
(define-constant verification-requirement u3)

;; Error Constants
(define-constant err-unauthorized-access (err u100))
(define-constant err-disaster-not-active (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-donation (err u103))
(define-constant err-proposal-already-executed (err u104))
(define-constant err-token-transfer-failed (err u105))
(define-constant err-not-token-holder (err u106))
(define-constant err-token-does-not-exist (err u107))
(define-constant err-already-registered-user (err u108))
(define-constant err-invalid-verification-proof (err u109))
(define-constant err-user-not-verified (err u110))

;; Data Variables
(define-data-var total-emergency-funds uint u0)
(define-data-var active-disaster-index uint u0)
(define-data-var last-nft-id uint u0)
(define-data-var last-victim-index uint u0)

;; Data Maps
(define-map emergency-donors 
    principal 
    {total-contributions: uint, 
     voting-weight: uint, 
     nft-balance: uint})

(define-map disaster-events 
    uint 
    {event-name: (string-ascii 64), 
     severity-level: uint, 
     funds-required: uint, 
     funds-allocated: uint, 
     is-active: bool})

(define-map relief-proposals
    uint 
    {proposal-details: (string-ascii 256),
     requested-amount: uint,
     total-votes: uint,
     is-executed: bool})

(define-map disaster-victims
    uint
    {user-address: principal,
     disaster-id: uint,
     location-details: (string-ascii 64),
     damage-assessment: uint,
     is-verified: bool,
     verification-count: uint,
     encrypted-information: (string-ascii 1024),
     verification-proof: (string-ascii 1024)})

(define-map victim-verifications
    {victim-id: uint, verifier-address: principal}
    bool)

(define-map trusted-verifiers
    principal
    bool)

(define-map nft-metadata
    uint 
    (string-ascii 256))

(define-map nft-owners
    uint
    principal)

;; NFT Implementation
(define-non-fungible-token emergency-nft uint)

;; Read-Only Functions
(define-read-only (get-donor-details (donor-address principal))
    (default-to 
        {total-contributions: u0, voting-weight: u0, nft-balance: u0}
        (map-get? emergency-donors donor-address)))

(define-read-only (get-disaster-details (disaster-id uint))
    (map-get? disaster-events disaster-id))

(define-read-only (get-victim-details (victim-id uint))
    (map-get? disaster-victims victim-id))

(define-read-only (check-verification-status (victim-id uint))
    (let ((victim (unwrap! (get-victim-details victim-id) (ok false))))
        (ok (get is-verified victim))))

(define-read-only (get-total-emergency-funds)
    (var-get total-emergency-funds))

(define-read-only (get-nft-owner (nft-id uint))
    (ok (map-get? nft-owners nft-id)))

(define-read-only (get-nft-metadata (nft-id uint))
    (ok (map-get? nft-metadata nft-id)))

(define-read-only (get-last-nft-id)
    (ok (var-get last-nft-id)))

;; Victim Registration Functions
(define-public (register-victim 
    (disaster-id uint)
    (location-details (string-ascii 64))
    (damage-assessment uint)
    (encrypted-information (string-ascii 1024))
    (verification-proof (string-ascii 1024)))
    (let ((victim-id (+ (var-get last-victim-index) u1))
          (disaster (unwrap! (get-disaster-details disaster-id) err-disaster-not-active)))
        (if (get is-active disaster)
            (begin
                (var-set last-victim-index victim-id)
                (map-set disaster-victims victim-id
                    {user-address: tx-sender,
                     disaster-id: disaster-id,
                     location-details: location-details,
                     damage-assessment: damage-assessment,
                     is-verified: false,
                     verification-count: u0,
                     encrypted-information: encrypted-information,
                     verification-proof: verification-proof})
                (ok victim-id))
            err-disaster-not-active)))

;; Oracle Management
(define-public (register-verifier (verifier-address principal))
    (if (is-eq tx-sender emergency-admin)
        (begin
            (map-set trusted-verifiers verifier-address true)
            (ok true))
        err-unauthorized-access))

(define-public (verify-victim-status (victim-id uint))
    (let (
        (victim (unwrap! (get-victim-details victim-id) err-unauthorized-access))
        (is-verifier (default-to false (map-get? trusted-verifiers tx-sender)))
        (has-verified (default-to false (map-get? victim-verifications {victim-id: victim-id, verifier-address: tx-sender})))
        )
        (if (and is-verifier (not has-verified))
            (begin
                (map-set victim-verifications {victim-id: victim-id, verifier-address: tx-sender} true)
                (map-set disaster-victims victim-id
                    (merge victim 
                        {verification-count: (+ (get verification-count victim) u1),
                         is-verified: (>= (+ (get verification-count victim) u1) verification-requirement)}))
                (ok true))
            err-unauthorized-access)))

;; Donation Function
(define-public (make-donation)
    (let ((donation-amount (stx-get-balance tx-sender))
          (donor-details (get-donor-details tx-sender)))
        (if (>= donation-amount min-donation-amount)
            (begin
                (try! (stx-transfer? donation-amount tx-sender (as-contract tx-sender)))
                (map-set emergency-donors tx-sender
                    {total-contributions: (+ (get total-contributions donor-details) donation-amount),
                     voting-weight: (+ (get voting-weight donor-details) donation-amount),
                     nft-balance: (+ (get nft-balance donor-details) u1)})
                (var-set total-emergency-funds (+ (var-get total-emergency-funds) donation-amount))
                (let ((new-nft-id (+ (var-get last-nft-id) u1)))
                    (var-set last-nft-id new-nft-id)
                    (try! (nft-mint? emergency-nft new-nft-id tx-sender))
                    (map-set nft-owners new-nft-id tx-sender)
                    (map-set nft-metadata new-nft-id nft-metadata-uri)
                    (ok true)))
            err-invalid-donation)))

(define-public (create-disaster-event (event-name (string-ascii 64)) (severity-level uint) (funds-required uint))
    (let ((disaster-id (+ (var-get active-disaster-index) u1)))
        (if (is-eq tx-sender emergency-admin)
            (begin
                (map-set disaster-events disaster-id
                    {event-name: event-name,
                     severity-level: severity-level,
                     funds-required: funds-required,
                     funds-allocated: u0,
                     is-active: true})
                (var-set active-disaster-index disaster-id)
                (ok disaster-id))
            err-unauthorized-access)))

(define-public (submit-relief-proposal (disaster-id uint) (proposal-details (string-ascii 256)) (requested-amount uint))
    (let ((disaster (unwrap! (get-disaster-details disaster-id) err-disaster-not-active)))
        (if (and 
                (get is-active disaster)
                (<= requested-amount (var-get total-emergency-funds)))
            (begin
                (map-set relief-proposals disaster-id
                    {proposal-details: proposal-details,
                     requested-amount: requested-amount,
                     total-votes: u0,
                     is-executed: false})
                (ok true))
            err-insufficient-balance)))

(define-public (vote-on-relief-proposal (disaster-id uint))
    (let ((proposal (unwrap! (map-get? relief-proposals disaster-id) err-disaster-not-active))
          (donor-details (get-donor-details tx-sender)))
        (if (not (get is-executed proposal))
            (begin
                (map-set relief-proposals disaster-id
                    (merge proposal {total-votes: (+ (get total-votes proposal) (get voting-weight donor-details))}))
                (ok true))
            err-proposal-already-executed)))

(define-public (transfer-nft (nft-id uint) (sender-address principal) (recipient-address principal))
    (let ((nft-holder (unwrap! (map-get? nft-owners nft-id) err-token-does-not-exist)))
        (if (and
                (is-eq tx-sender sender-address)
                (is-eq nft-holder sender-address))
            (begin
                (map-set nft-owners nft-id recipient-address)
                (ok true))
            err-not-token-holder)))

(define-public (update-disaster-severity (disaster-id uint) (new-severity-level uint))
    (let ((disaster (unwrap! (get-disaster-details disaster-id) err-disaster-not-active)))
        (if (is-eq tx-sender emergency-admin)
            (begin
                (map-set disaster-events disaster-id
                    (merge disaster {severity-level: new-severity-level})) 
                (ok true))
            err-unauthorized-access)))