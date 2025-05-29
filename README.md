# Blockchain-Based Environmental Ecosystem Restoration

A comprehensive smart contract system built on the Stacks blockchain for managing and verifying environmental ecosystem restoration projects. This system provides end-to-end tracking from project initiation through outcome verification.

## Overview

This project implements a decentralized platform for environmental restoration that ensures transparency, accountability, and verifiable outcomes through blockchain technology. The system consists of five interconnected smart contracts that manage the complete restoration lifecycle.

## System Architecture

### Core Contracts

1. **Restoration Registry** (`restoration-registry.clar`)
    - Central registry for all restoration projects
    - Project creation and status management
    - Participant authorization and role assignment

2. **Baseline Assessment** (`baseline-assessment.clar`)
    - Records pre-restoration environmental conditions
    - Detailed metric tracking and verification
    - Scientific assessment validation

3. **Restoration Methodology** (`restoration-methodology.clar`)
    - Defines restoration approaches and techniques
    - Phase-based implementation planning
    - Methodology approval workflow

4. **Progress Monitoring** (`progress-monitoring.clar`)
    - Milestone tracking and status updates
    - Regular progress reporting
    - Timeline and deliverable management

5. **Outcome Verification** (`outcome-verification.clar`)
    - Final restoration success validation
    - Multi-verifier assessment system
    - Certification level assignment

## Key Features

### Project Lifecycle Management
- **Project Registration**: Create and register new restoration projects
- **Status Tracking**: Monitor project progression through defined stages
- **Participant Management**: Assign roles and permissions to stakeholders

### Scientific Rigor
- **Baseline Documentation**: Comprehensive pre-restoration condition recording
- **Methodology Validation**: Peer-reviewed restoration approach approval
- **Evidence-Based Monitoring**: Regular progress tracking with verifiable data

### Verification System
- **Multi-Stakeholder Verification**: Independent assessment by multiple verifiers
- **Evidence Submission**: Cryptographic proof of restoration outcomes
- **Certification Levels**: Bronze, Silver, Gold, and Platinum certifications

### Data Integrity
- **Immutable Records**: All data permanently stored on blockchain
- **Cryptographic Hashing**: Evidence integrity through hash verification
- **Transparent Auditing**: Public access to project data and progress

## Contract Functions

### Restoration Registry
\`\`\`clarity
;; Create a new restoration project
(create-project name location ecosystem-type area-hectares target-completion)

;; Update project status
(update-project-status project-id new-status)

;; Add project participants
(add-participant project-id participant role)
\`\`\`

### Baseline Assessment
\`\`\`clarity
;; Record baseline environmental conditions
(record-baseline-assessment project-id soil-quality biodiversity water-quality vegetation carbon-stock)

;; Add detailed assessment metrics
(add-assessment-detail project-id metric value unit notes)

;; Verify assessment data
(verify-assessment project-id)
\`\`\`

### Progress Monitoring
\`\`\`clarity
;; Add project milestones
(add-milestone project-id milestone-name target-date completion-criteria)

;; Submit progress reports
(submit-progress-report project-id activities challenges next-steps overall-progress)

;; Verify milestone completion
(verify-milestone project-id milestone-id)
\`\`\`

### Outcome Verification
\`\`\`clarity
;; Initiate final verification
(initiate-outcome-verification project-id success-score biodiversity carbon soil water)

;; Submit verifier assessment
(submit-verifier-assessment project-id success-rating comments)

;; Submit verification evidence
(submit-verification-evidence project-id evidence-type description data-hash)
\`\`\`

## Project Status Flow

1. **Proposed** (0) - Initial project submission
2. **Approved** (1) - Project approved for implementation
3. **In Progress** (2) - Active restoration work
4. **Completed** (3) - Restoration activities finished
5. **Verified** (4) - Outcomes verified and certified

## Certification Levels

- **Platinum** (90-100%): Exceptional restoration success
- **Gold** (80-89%): High-quality restoration outcomes
- **Silver** (70-79%): Satisfactory restoration results
- **Bronze** (60-69%): Basic restoration requirements met

## Testing

The project includes comprehensive test suites for all contracts:

\`\`\`bash
# Run all tests
npm test

# Run specific contract tests
npm test restoration-registry
npm test baseline-assessment
npm test progress-monitoring
npm test outcome-verification
\`\`\`

## Deployment

### Prerequisites
- Stacks CLI installed
- Clarinet development environment
- Testnet STX tokens for deployment

### Deploy Contracts
\`\`\`bash
# Deploy to testnet
clarinet deployments apply --network testnet

# Deploy to mainnet
clarinet deployments apply --network mainnet
\`\`\`

## Usage Examples

### Creating a Restoration Project
\`\`\`clarity
(contract-call? .restoration-registry create-project
"Amazon Rainforest Restoration"
"Brazil, Para State"
"Tropical Rainforest"
u500
u1000)
\`\`\`

### Recording Baseline Assessment
\`\`\`clarity
(contract-call? .baseline-assessment record-baseline-assessment
u1  ;; project-id
u65 ;; soil-quality-score
u45 ;; biodiversity-index
u70 ;; water-quality-score
u30 ;; vegetation-coverage
u120) ;; carbon-stock
\`\`\`

### Submitting Progress Report
\`\`\`clarity
(contract-call? .progress-monitoring submit-progress-report
u1
"Cleared 50% of invasive species"
"Heavy rainfall caused delays"
"Continue clearing, begin planting"
u25)
\`\`\`

## Environmental Impact

This system enables:
- **Transparent Restoration**: Public verification of environmental claims
- **Incentivized Conservation**: Reward mechanisms for successful restoration
- **Scientific Accountability**: Evidence-based restoration validation
- **Global Coordination**: Standardized restoration tracking worldwide

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For technical support or questions:
- Create an issue in the GitHub repository
- Contact the development team
- Join our community Discord

## Roadmap

- [ ] Integration with satellite monitoring systems
- [ ] Carbon credit tokenization
- [ ] Mobile app for field data collection
- [ ] AI-powered restoration outcome prediction
- [ ] Cross-chain compatibility for broader adoption
