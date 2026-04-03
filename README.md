# ArcVault Launchpad

ArcVault Launchpad is a tokenized asset launchpad built on Arc Testnet. It lets founders launch equity, revenue-share, and real-world asset offerings, raise in USDC, and give investors a clean onchain interface for discovery and participation.

## Live Contract

- Launchpad: `0x2feA3305fcB02184b2e120B1D511D3f539F276B7`
- Network: Arc Testnet
- Chain ID: `5042002`
- RPC: `https://rpc.testnet.arc.network`
- Explorer: [https://testnet.arcscan.app](https://testnet.arcscan.app)

## What It Does

- Launch tokenized assets on Arc Testnet
- Support multiple asset classes:
  - Equity
  - Revenue Share
  - Real-World Assets
- Raise in USDC
- Connect wallet with MetaMask
- Browse listed offerings
- Simulate investing through the frontend
- Display Arc-native deploy references and contract info

## Project Structure

```text
arc-launchpad/
├── contracts/
│   ├── AssetLaunchpad.sol
│   └── AssetToken.sol
├── script/
│   └── DeployLaunchpad.s.sol
├── src/
├── test/
├── broadcast/
├── cache/
├── out/
├── index.html
├── foundry.toml
└── README.md

Smart Contract Deployment
The launchpad contract has already been deployed successfully to Arc Testnet.

Deployment summary:

Deployer:          0x98ba9B32699F148940E6785E0A1aceF8b38a828D
Launchpad address: 0x2feA3305fcB02184b2e120B1D511D3f539F276B7
Fee recipient:     0x98ba9B32699F148940E6785E0A1aceF8b38a828D
Network:           Arc Testnet
Chain ID:          5042002
RPC:               https://rpc.testnet.arc.network
Explorer:          https://testnet.arcscan.app
Frontend
The frontend is a single-file static app built with:

HTML
CSS
Vanilla JavaScript
It is designed to be deployed easily on Vercel and connected to the already deployed Arc Testnet contract.

The frontend is currently configured with:

LAUNCHPAD_ADDRESS = 0x2feA3305fcB02184b2e120B1D511D3f539F276B7
ARC_RPC = https://rpc.testnet.arc.network
CHAIN_ID = 5042002
USDC_ADDRESS = 0x3600000000000000000000000000000000000000
Local Development
If you just want to preview the frontend locally, open index.html in a browser or use a simple local server.

Example:

python3 -m http.server 5500
Then open:

http://localhost:5500
Foundry Setup
Install Foundry:

curl -L https://foundry.paradigm.xyz | bash
foundryup
Clone the repo and install dependencies:

git clone https://github.com/YOUR_USERNAME/arc-launchpad.git
cd arc-launchpad
forge install
Create your environment file:

cp .env.example .env
Example .env:

ARC_TESTNET_RPC_URL=https://rpc.testnet.arc.network
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
Redeploy Smart Contracts
If you want to redeploy the launchpad contract to Arc Testnet again:

forge script script/DeployLaunchpad.s.sol \
  --rpc-url $ARC_TESTNET_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
After deploy:

Copy the new launchpad contract address from the terminal output
Replace the LAUNCHPAD_ADDRESS constant inside index.html
Commit and push the updated frontend
Redeploy on Vercel
GitHub Deployment



Wallet / Network Details
To use the app in MetaMask:

Network name: Arc Testnet
RPC URL: https://rpc.testnet.arc.network
Chain ID: 5042002
Currency symbol: USDC
Explorer: https://testnet.arcscan.app
Notes
The current deployment is on Arc Testnet, not mainnet
The frontend contains demo/mock asset data
To make the app fully onchain-driven, the frontend should read actual asset listings from the deployed contract
License
MIT

