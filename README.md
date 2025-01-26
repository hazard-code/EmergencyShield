# EmergencyShield: Decentralized Disaster Relief Protocol

EmergencyShield is a decentralized, transparent, and fair disaster relief fund management system built on the Stacks blockchain. It leverages smart contracts to ensure accountability, efficiency, and trust in disaster relief operations. The protocol enables donors to contribute funds, victims to register for aid, and verifiers to validate claims, all while maintaining a transparent and immutable record of transactions and decisions.

---

## Features

1. **Transparent Donations**  
   Donors can contribute funds to the EmergencyShield protocol and receive NFTs as proof of their contribution. These NFTs also grant voting power for relief fund allocation decisions.

2. **Victim Registration**  
   Victims of disasters can register on the platform by providing necessary details, including location, damage assessment, and encrypted data for verification.

3. **Decentralized Verification**  
   Trusted oracles (verifiers) validate victim claims to ensure legitimacy. A threshold of verifications is required to confirm a victim's eligibility for relief funds.

4. **Relief Proposals**  
   Relief proposals can be created for specific disasters, and donors can vote on how funds should be allocated. Proposals are executed once they meet the voting threshold.

5. **Immutable Records**  
   All transactions, registrations, and verifications are recorded on the blockchain, ensuring transparency and preventing fraud.

6. **NFT-Based Incentives**  
   Donors receive NFTs representing their contributions, which can be used for voting or transferred to others.

---

## How It Works

### 1. **Donations**
   - Donors contribute funds to the EmergencyShield protocol.
   - In return, they receive an NFT representing their contribution and gain voting power proportional to their donation.

### 2. **Disaster Registration**
   - Admins can register new disaster events, specifying the severity level and funds required.
   - Only authorized admins can create or update disaster events.

### 3. **Victim Registration**
   - Victims register by providing details such as location, damage level, and encrypted data.
   - Victims must provide proof of their situation, which is verified by trusted oracles.

### 4. **Verification**
   - Trusted oracles verify victim claims by reviewing the provided data and proof.
   - Once a victim receives enough verifications, they are marked as eligible for relief.

### 5. **Relief Proposals**
   - Relief proposals are created to allocate funds for specific disasters.
   - Donors vote on proposals using their voting power.
   - Proposals are executed once they meet the voting threshold.

### 6. **Fund Allocation**
   - Funds are allocated to victims based on verified claims and approved proposals.
   - All transactions are recorded on the blockchain for transparency.

---

## Smart Contract Functions

### For Donors
- **`make-donation`**: Contribute funds and receive an NFT.
- **`vote-on-relief-proposal`**: Vote on relief proposals using voting power.

### For Victims
- **`register-victim`**: Register as a victim by providing necessary details.
- **`check-verification-status`**: Check if a victim's claim has been verified.

### For Admins
- **`create-disaster-event`**: Register a new disaster event.
- **`update-disaster-severity`**: Update the severity level of a disaster.
- **`register-verifier`**: Add a trusted oracle to the system.

### For Verifiers
- **`verify-victim-status`**: Verify a victim's claim.

### For NFT Holders
- **`transfer-nft`**: Transfer ownership of an NFT to another address.

---

## Error Handling

The contract includes robust error handling to ensure proper usage:
- **Unauthorized Access**: Only admins can perform certain actions.
- **Insufficient Funds**: Donations must meet the minimum amount.
- **Invalid Data**: Victims must provide valid proof and details.
- **Proposal Execution**: Proposals can only be executed once.

---

## Installation and Deployment

### Prerequisites
- Stacks CLI installed.
- A Stacks wallet with testnet or mainnet STX tokens.

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/emergencyshield.git
   cd emergencyshield
   ```
2. Deploy the contract using the Stacks CLI:
   ```bash
   clarinet deploy
   ```
3. Interact with the contract using the Stacks CLI or a web interface.

---

## Use Cases

1. **Natural Disasters**  
   EmergencyShield can be used to manage relief funds for hurricanes, earthquakes, floods, and other natural disasters.

2. **Humanitarian Crises**  
   The protocol can facilitate aid distribution in conflict zones or refugee camps.

3. **Community Support**  
   Local communities can use EmergencyShield to raise and allocate funds for local emergencies.

---

## Future Enhancements

1. **Multi-Chain Support**  
   Extend the protocol to other blockchains for broader accessibility.

2. **Integration with IoT Devices**  
   Use IoT devices to automatically verify disaster-related data (e.g., flood sensors).

3. **Decentralized Identity (DID)**  
   Implement DID for secure and privacy-preserving victim identification.

4. **Gamification**  
   Reward donors and verifiers with additional tokens or NFTs for active participation.

---

## Contributing

We welcome contributions to EmergencyShield! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

---

## License

EmergencyShield is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## Contact

For questions or support, please reach out to:
- **Email**: support@emergencyshield.org
- **Twitter**: [@EmergencyShield](https://twitter.com/EmergencyShield)
- **Discord**: Join our [community server](https://discord.gg/emergencyshield).

---

## Acknowledgments

- The Stacks community for their support and resources.
- All contributors and donors who make EmergencyShield possible.

---

**EmergencyShield: Empowering Communities, Saving Lives.**