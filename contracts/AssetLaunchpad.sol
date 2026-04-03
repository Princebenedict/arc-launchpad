// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AssetToken} from "./AssetToken.sol";

/**
 * @title AssetLaunchpad
 * @notice Factory — founders call launchAsset() to deploy a new AssetToken
 */
contract AssetLaunchpad {
    using SafeERC20 for IERC20;

    address public constant USDC = 0x3600000000000000000000000000000000000000;
    uint256 public constant LISTING_FEE = 1_000_000; // 1 USDC (6 decimals)

    address public immutable FEE_RECIPIENT;

    struct ListedAsset {
        address tokenContract;
        string name;
        string symbol;
        address founder;
        AssetToken.AssetType assetType;
        uint256 listedAt;
    }

    ListedAsset[] private _assets;
    mapping(address => address[]) public founderAssets;
    mapping(address => bool) public isRegistered;

    event AssetLaunched(
        address indexed tokenContract,
        address indexed founder,
        string name,
        string symbol,
        AssetToken.AssetType assetType,
        uint256 listedAt
    );

    constructor(address _feeRecipient) {
        FEE_RECIPIENT = _feeRecipient;
    }

    /**
     * @notice Deploy a new tokenized asset
     * @dev Charges 1 USDC listing fee. Make sure to approve USDC first.
     */
    function launchAsset(
        string memory name,
        string memory symbol,
        string memory companyName,
        string memory description,
        AssetToken.AssetType assetType,
        uint256 totalValuation,
        uint256 pricePerToken,
        uint256 maxSupply
    ) external returns (address) {
        // Collect 1 USDC listing fee
        IERC20(USDC).safeTransferFrom(msg.sender, FEE_RECIPIENT, LISTING_FEE);

        // Deploy a new AssetToken contract for this asset
        AssetToken token = new AssetToken(
            name, symbol, companyName, description, assetType, totalValuation, pricePerToken, maxSupply, msg.sender
        );

        address tokenAddr = address(token);

        _assets.push(
            ListedAsset({
                tokenContract: tokenAddr,
                name: name,
                symbol: symbol,
                founder: msg.sender,
                assetType: assetType,
                listedAt: block.timestamp
            })
        );

        founderAssets[msg.sender].push(tokenAddr);
        isRegistered[tokenAddr] = true;

        emit AssetLaunched(tokenAddr, msg.sender, name, symbol, assetType, block.timestamp);
        return tokenAddr;
    }

    function totalAssets() external view returns (uint256) {
        return _assets.length;
    }

    function getAsset(uint256 index) external view returns (ListedAsset memory) {
        require(index < _assets.length, "Out of range");
        return _assets[index];
    }

    function getAllAssets() external view returns (ListedAsset[] memory) {
        return _assets;
    }

    function getFounderAssets(address founder) external view returns (address[] memory) {
        return founderAssets[founder];
    }
}
