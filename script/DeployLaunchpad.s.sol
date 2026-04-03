// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {AssetLaunchpad} from "../contracts/AssetLaunchpad.sol";

contract DeployLaunchpad is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the launchpad. Fee recipient = deployer (change to your treasury)
        AssetLaunchpad launchpad = new AssetLaunchpad(deployer);

        vm.stopBroadcast();

        console.log("============================================");
        console.log("   ArcVault Launchpad Deployed");
        console.log("============================================");
        console.log("Deployer:          ", deployer);
        console.log("Launchpad address: ", address(launchpad));
        console.log("Fee recipient:     ", deployer);
        console.log("Network:            Arc Testnet");
        console.log("Chain ID:           5042002");
        console.log("RPC:                https://rpc.testnet.arc.network");
        console.log("Explorer:           https://testnet.arcscan.app");
        console.log("============================================");
        console.log("Next: copy the launchpad address into your .env");
        console.log("  LAUNCHPAD_ADDRESS=<address above>");
    }
}
