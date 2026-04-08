# ArcVault

> Arc-native launchpad for real-world assets. Launch onchain asset tokens, fund them with USDC, and manage investor positions through a contract-backed frontend.

[![Foundry](https://img.shields.io/badge/Built%20With-Foundry-f0b90b)](#local-development)
[![Arc Testnet](https://img.shields.io/badge/Network-Arc%20Testnet-00d4aa)](#deployed-addresses)
[![Vercel](https://img.shields.io/badge/Frontend-Vercel-black)](#live-demo)
[![License](https://img.shields.io/badge/License-MIT-green)](#license)

## Live Demo
[https://arc-launchpad.vercel.app/](https://arc-launchpad.vercel.app/)

## One-Line Pitch
ArcVault turns asset issuance and investment into an onchain experience: founders launch tokenized offerings, investors discover real contract-created listings, buy with USDC, and claim dividends directly from the app.

## The Problem
Access to real-world asset participation is still fragmented:
- founders rely on slow, manual fundraising flows
- investors face opaque access and weak transparency
- product experiences often show mock data instead of real contract state
- portfolio visibility is rarely tied directly to deployed token contracts

## The Solution
ArcVault solves that with a launchpad built around real onchain primitives:
- a factory contract deploys an asset token per listing
- the frontend reads only actual launchpad-created assets
- risk tier is stored onchain
- purchase cost basis is stored onchain
- investors interact with live contracts through wallet actions

## Why It Stands Out
- Real contract-backed asset listings, not seeded mock cards
- Onchain risk metadata
- Onchain investor cost basis tracking
- USDC-denominated asset purchase flow
- Clean explorer, launch, and portfolio UX in one interface
- Built specifically around Arc Testnet deployment

## Core Features
- Launch new asset tokens from `AssetLaunchpad`
- Deploy dedicated `AssetToken` contracts for each asset
- Explore only onchain-created listings
- Buy tokens with USDC
- Track portfolio positions by wallet
- Claim dividends directly from token contracts
- View asset metadata including type, risk tier, valuation, and pricing

## Product Flow
```text
Founder
  -> launches asset via AssetLaunchpad
  -> AssetLaunchpad deploys AssetToken
  -> asset becomes visible in Explore

Investor
  -> Explore reads launchpad contract
  -> Selects an onchain asset
  -> Approves USDC
  -> Purchases tokens
  -> Portfolio reads holdings from token contracts
  -> Claims dividends from token contract

Contract Design
AssetLaunchpad
Factory contract responsible for:

charging listing fee in USDC
deploying new AssetToken contracts
storing asset registry data
exposing all launched assets to the frontend
AssetToken
Per-asset contract responsible for:

asset metadata
company information
asset type
risk tier
valuation
token price
max supply
total raised
total invested per wallet
total purchased tokens per wallet
dividend distribution and claiming

Deployed Addresses
Launchpad: 0x705C2b9D3B06eeF72831F463Ca6eBc5A9B543e3b
USDC:      0x3600000000000000000000000000000000000000
Network:   Arc Testnet
Chain ID:  5042002
RPC:       https://rpc.testnet.arc.network
Explorer:  https://testnet.arcscan.app



Frontend Highlights
The frontend is intentionally wired to real chain data:

Explore Assets reads directly from AssetLaunchpad.getAllAssets()
each asset card is enriched from the live AssetToken contract
Launch Asset writes directly onchain
Portfolio reads balances, pending dividends, and cost basis from contracts
risk tier is not guessed in the UI



Tech Stack
Solidity
Foundry
Ethers.js
HTML
CSS
JavaScript
GitHub Actions
Vercel





Repository Structure
arc-launchpad/
├── contracts/
│   ├── AssetToken.sol          ← ERC-20 per asset + dividends
│   └── AssetLaunchpad.sol      ← Factory that deploys AssetTokens
├── script/
│   └── DeployLaunchpad.s.sol   ← Foundry deploy script
├── test/
│   └── AssetLaunchpad.t.sol    ← Unit tests
├── .env                        ← your secrets (never commit)
├── foundry.toml                ← Foundry config
├── .gitignore
└── index.html                  ← Full frontend wired to Arc




Local Development

Build
forge build

Test
forge test

Format
forge fmt

Check formatting
forge fmt --check


Deploy Contracts
Deployment uses the Foundry script and reads PRIVATE_KEY from the environment.

PRIVATE_KEY=0xYOUR_PRIVATE_KEY forge script script/DeployLaunchpad.s.sol:DeployLaunchpad --rpc-url https://rpc.testnet.arc.network --broadcast
After deployment:

copy the new launchpad address from the logs
update LAUNCHPAD_ADDRESS in index.html
update the address in this README
push the changes to GitHub
Redeploy Frontend
After updating index.html:

git add .
git commit -m "Update frontend for redeployed launchpad"
git push origin main
If Vercel is connected to GitHub, the site redeploys automatically.

CI Notes
This repo uses Foundry CI checks. If CI fails on formatting:

forge fmt
git add .
git commit -m "chore: format solidity files"
git push origin main




Demo Walkthrough
Connect wallet
Launch asset from the launch form
Explore live contract-created listings
Select a tokenized asset
Approve USDC
Invest onchain
View live portfolio holdings
Claim dividends



Future Improvements
event indexing for faster data loading
founder analytics dashboard
deeper portfolio analytics
stronger secondary market settlement
onchain buyback / redemption mechanics
richer investor protection logic



Author
Princebenedict



License
MIT