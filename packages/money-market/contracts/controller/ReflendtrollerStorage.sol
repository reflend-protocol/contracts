// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "../token/RToken.sol";
import "../oracle/PriceOracle.sol";

contract UnitrollerAdminStorage {
    /**
     * @notice Administrator for this contract
     */
    address public admin;

    /**
     * @notice Pending administrator for this contract
     */
    address public pendingAdmin;

    /**
     * @notice Active brains of Unitroller
     */
    address public reflendtrollerImplementation;

    /**
     * @notice Pending brains of Unitroller
     */
    address public pendingReflendtrollerImplementation;
}

contract ReflendtrollerV1Storage is UnitrollerAdminStorage {
    /**
     * @notice Oracle which gives the price of any given asset
     */
    PriceOracle public oracle;

    /**
     * @notice Multiplier used to calculate the maximum repayAmount when liquidating a borrow
     */
    uint public closeFactorMantissa;

    /**
     * @notice Multiplier representing the discount on collateral that a liquidator receives
     */
    uint public liquidationIncentiveMantissa;

    /**
     * @notice Max number of assets a single account can participate in (borrow or use as collateral)
     */
    uint public maxAssets;

    /**
     * @notice Per-account mapping of "assets you are in", capped by maxAssets
     */
    mapping(address => RToken[]) public accountAssets;
}

contract ReflendtrollerV2Storage is ReflendtrollerV1Storage {
    struct Market {
        // Whether or not this market is listed
        bool isListed;
        //  Multiplier representing the most one can borrow against their collateral in this market.
        //  For instance, 0.9 to allow borrowing 90% of collateral value.
        //  Must be between 0 and 1, and stored as a mantissa.
        uint collateralFactorMantissa;
        // Per-market mapping of "accounts in this asset"
        mapping(address => bool) accountMembership;
        // Whether or not this market receives COMP
        bool isReflended;
    }

    /**
     * @notice Official mapping of lTokens -> Market metadata
     * @dev Used e.g. to determine if a market is supported
     */
    mapping(address => Market) public markets;

    /**
     * @notice The Pause Guardian can pause certain actions as a safety mechanism.
     *  Actions which allow users to remove their own assets cannot be paused.
     *  Liquidation / seizing / transfer can only be paused globally, not by market.
     */
    address public pauseGuardian;
    bool public _mintGuardianPaused;
    bool public _borrowGuardianPaused;
    bool public transferGuardianPaused;
    bool public seizeGuardianPaused;
    mapping(address => bool) public mintGuardianPaused;
    mapping(address => bool) public borrowGuardianPaused;
}

contract ReflendtrollerV3Storage is ReflendtrollerV2Storage {
    struct ReflendMarketState {
        // The market's last updated reflendBorrowIndex or reflendSupplyIndex
        uint224 index;
        // The block number the index was last updated at
        uint32 block;
    }

    /// @notice A list of all markets
    RToken[] public allMarkets;

    /// @notice The rate at which the flywheel distributes COMP, per block
    uint public reflendRate;

    /// @notice The portion of reflendRate that each market currently receives
    mapping(address => uint) public reflendSpeeds;

    /// @notice The COMP market supply state for each market
    mapping(address => ReflendMarketState) public reflendSupplyState;

    /// @notice The COMP market borrow state for each market
    mapping(address => ReflendMarketState) public reflendBorrowState;

    /// @notice The COMP borrow index for each market for each supplier as of the last time they accrued COMP
    mapping(address => mapping(address => uint)) public reflendSupplierIndex;

    /// @notice The COMP borrow index for each market for each borrower as of the last time they accrued COMP
    mapping(address => mapping(address => uint)) public reflendBorrowerIndex;

    /// @notice The COMP accrued but not yet transferred to each user
    mapping(address => uint) public reflendAccrued;
}

contract ReflendtrollerV4Storage is ReflendtrollerV3Storage {
    // @notice The borrowCapGuardian can set borrowCaps to any number for any market. Lowering the borrow cap could disable borrowing on the given market.
    address public borrowCapGuardian;

    // @notice Borrow caps enforced by borrowAllowed for each lToken address. Defaults to zero which corresponds to unlimited borrowing.
    mapping(address => uint) public borrowCaps;
}

contract ReflendtrollerV5Storage is ReflendtrollerV4Storage {
    /// @notice The portion of COMP that each contributor receives per block
    mapping(address => uint) public reflendContributorSpeeds;

    /// @notice Last block at which a contributor's COMP rewards have been allocated
    mapping(address => uint) public lastContributorBlock;
}

contract ReflendtrollerV6Storage is ReflendtrollerV5Storage {
    /// @notice The rate at which reflend is distributed to the corresponding borrow market (per block)
    mapping(address => uint) public reflendBorrowSpeeds;

    /// @notice The rate at which reflend is distributed to the corresponding supply market (per block)
    mapping(address => uint) public reflendSupplySpeeds;
}

contract ReflendtrollerV7Storage is ReflendtrollerV6Storage {
    /// @notice Flag indicating whether the function to fix COMP accruals has been executed (RE: proposal 62 bug)
    bool public proposal65FixExecuted;

    /// @notice Accounting storage mapping account addresses to how much COMP they owe the protocol.
    mapping(address => uint) public reflendReceivable;
}
