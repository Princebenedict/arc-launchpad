// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title AssetToken
 * @notice Tokenized asset (equity, revenue share, or RWA) on Arc
 * @dev ERC-20 with USDC-based purchase and dividend distribution
 */
contract AssetToken {
    using SafeERC20 for IERC20;

    // Arc Testnet native USDC address
    address public constant USDC = 0x3600000000000000000000000000000000000000;

    // ---- ERC-20 state ----
    string public name;
    string public symbol;
    uint8 public constant DECIMALS = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ---- Asset metadata ----
    enum AssetType {
        EQUITY,
        REVENUE_SHARE,
        RWA
    }

    string public companyName;
    string public description;
    AssetType public assetType;
    uint256 public totalValuation; // USDC, 6 decimals
    uint256 public pricePerToken; // USDC, 6 decimals
    uint256 public maxSupply; // token units (no decimals)
    bool public isActive;
    address public founder;
    uint256 public createdAt;

    // ---- Financials ----
    uint256 public totalRaised;
    uint256 public dividendsPerTokenScaled; // scaled by 1e18
    mapping(address => uint256) public dividendDebt; // per holder

    // ---- Events ----
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TokensPurchased(address indexed buyer, uint256 tokenAmount, uint256 usdcPaid);
    event DividendsDistributed(uint256 usdcAmount);
    event DividendsClaimed(address indexed holder, uint256 usdcAmount);
    event AssetDeactivated();

    modifier onlyFounder() {
        _onlyFounder();
        _;
    }

    function _onlyFounder() internal view {
        require(msg.sender == founder, "Not founder");
    }

    modifier onlyActive() {
        _onlyActive();
        _;
    }

    function _onlyActive() internal view {
        require(isActive, "Asset is not active");
    }

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _companyName,
        string memory _description,
        AssetType _assetType,
        uint256 _totalValuation,
        uint256 _pricePerToken,
        uint256 _maxSupply,
        address _founder
    ) {
        name = _name;
        symbol = _symbol;
        companyName = _companyName;
        description = _description;
        assetType = _assetType;
        totalValuation = _totalValuation;
        pricePerToken = _pricePerToken;
        maxSupply = _maxSupply;
        founder = _founder;
        isActive = true;
        createdAt = block.timestamp;
    }

    // ERC-20 compatibility
    function decimals() external pure returns (uint8) {
        return DECIMALS;
    }

    // ---- ERC-20 functions ----

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
        allowance[from][msg.sender] -= amount;
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0) && to != address(0), "Zero address");
        require(balanceOf[from] >= amount, "Insufficient balance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    // ---- Core launchpad logic ----

    function purchaseTokens(uint256 tokenAmount) external onlyActive {
        require(tokenAmount > 0, "Amount must be > 0");
        uint256 tokenAmountScaled = tokenAmount * 1e18;
        require(totalSupply + tokenAmountScaled <= maxSupply * 1e18, "Exceeds max supply");

        uint256 usdcCost = tokenAmount * pricePerToken;

        IERC20(USDC).safeTransferFrom(msg.sender, address(this), usdcCost);

        totalRaised += usdcCost;
        dividendDebt[msg.sender] = dividendsPerTokenScaled;

        _mint(msg.sender, tokenAmountScaled);
        emit TokensPurchased(msg.sender, tokenAmountScaled, usdcCost);
    }

    function distributeDividends(uint256 usdcAmount) external onlyFounder {
        require(totalSupply > 0, "No tokens minted");
        require(usdcAmount > 0, "Amount must be > 0");

        IERC20(USDC).safeTransferFrom(msg.sender, address(this), usdcAmount);

        dividendsPerTokenScaled += (usdcAmount * 1e18) / totalSupply;
        emit DividendsDistributed(usdcAmount);
    }

    function claimDividends() external {
        uint256 owed = pendingDividends(msg.sender);
        require(owed > 0, "Nothing to claim");
        dividendDebt[msg.sender] = dividendsPerTokenScaled;
        IERC20(USDC).safeTransfer(msg.sender, owed);
        emit DividendsClaimed(msg.sender, owed);
    }

    function pendingDividends(address holder) public view returns (uint256) {
        uint256 unclaimed = dividendsPerTokenScaled - dividendDebt[holder];
        return (balanceOf[holder] * unclaimed) / 1e18;
    }

    function withdrawRaised(uint256 amount) external onlyFounder {
        IERC20(USDC).safeTransfer(founder, amount);
    }

    function deactivate() external onlyFounder {
        isActive = false;
        emit AssetDeactivated();
    }
}
