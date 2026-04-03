// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {AssetToken} from "../contracts/AssetToken.sol";
import {AssetLaunchpad} from "../contracts/AssetLaunchpad.sol";

contract AssetLaunchpadTest is Test {
    AssetToken public token;
    address public founder = makeAddr("founder");
    address public investor = makeAddr("investor");

    function setUp() public {
        vm.prank(founder);
        token = new AssetToken(
            "Acme Equity Token",
            "ACME",
            "Acme Corporation",
            "Leading tech startup in Lagos",
            AssetToken.AssetType.EQUITY,
            1_000_000_000_000, // $1M valuation (6 decimals)
            10_000_000, // $10 per token (6 decimals)
            100_000, // 100k max tokens
            founder
        );
    }

    function testMetadata() public view {
        assertEq(token.name(), "Acme Equity Token");
        assertEq(token.symbol(), "ACME");
        assertEq(token.companyName(), "Acme Corporation");
        assertEq(token.pricePerToken(), 10_000_000);
        assertEq(token.maxSupply(), 100_000);
        assertTrue(token.isActive());
        assertEq(token.founder(), founder);
        assertEq(uint256(token.assetType()), uint256(AssetToken.AssetType.EQUITY));
    }

    function testDeactivateByFounder() public {
        assertTrue(token.isActive());
        vm.prank(founder);
        token.deactivate();
        assertFalse(token.isActive());
    }

    function testNonFounderCannotDeactivate() public {
        vm.prank(investor);
        vm.expectRevert("Not founder");
        token.deactivate();
    }

    function testNonFounderCannotWithdraw() public {
        vm.prank(investor);
        vm.expectRevert("Not founder");
        token.withdrawRaised(1000);
    }

    function testInitialSupplyZero() public view {
        assertEq(token.totalSupply(), 0);
        assertEq(token.totalRaised(), 0);
    }

    function testLaunchpadDeployment() public {
        address feeRecipient = makeAddr("feeRecipient");
        AssetLaunchpad launchpad = new AssetLaunchpad(feeRecipient);
        assertEq(launchpad.totalAssets(), 0);
        assertEq(launchpad.FEE_RECIPIENT(), feeRecipient);
    }
}
