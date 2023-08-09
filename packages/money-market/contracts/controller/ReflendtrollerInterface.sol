// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

abstract contract ReflendtrollerInterface {
    /// @notice Indicator that this is a Reflendtroller contract (for inspection)
    bool public constant isReflendtroller = true;

    /*** Assets You Are In ***/

    function enterMarkets(address[] calldata lTokens) external virtual returns (uint[] memory);

    function exitMarket(address lToken) external virtual returns (uint);

    /*** Policy Hooks ***/

    function mintAllowed(
        address lToken,
        address minter,
        uint mintAmount
    ) external virtual returns (uint);

    function mintVerify(
        address lToken,
        address minter,
        uint mintAmount,
        uint minlTokens
    ) external virtual;

    function redeemAllowed(
        address lToken,
        address redeemer,
        uint redeemTokens
    ) external virtual returns (uint);

    function redeemVerify(
        address lToken,
        address redeemer,
        uint redeemAmount,
        uint redeemTokens
    ) external virtual;

    function borrowAllowed(
        address lToken,
        address borrower,
        uint borrowAmount
    ) external virtual returns (uint);

    function borrowVerify(address lToken, address borrower, uint borrowAmount) external virtual;

    function repayBorrowAllowed(
        address lToken,
        address payer,
        address borrower,
        uint repayAmount
    ) external virtual returns (uint);

    function repayBorrowVerify(
        address lToken,
        address payer,
        address borrower,
        uint repayAmount,
        uint borrowerIndex
    ) external virtual;

    function liquidateBorrowAllowed(
        address lTokenBorrowed,
        address lTokenCollateral,
        address liquidator,
        address borrower,
        uint repayAmount
    ) external virtual returns (uint);

    function liquidateBorrowVerify(
        address lTokenBorrowed,
        address lTokenCollateral,
        address liquidator,
        address borrower,
        uint repayAmount,
        uint seizeTokens
    ) external virtual;

    function seizeAllowed(
        address lTokenCollateral,
        address lTokenBorrowed,
        address liquidator,
        address borrower,
        uint seizeTokens
    ) external virtual returns (uint);

    function seizeVerify(
        address lTokenCollateral,
        address lTokenBorrowed,
        address liquidator,
        address borrower,
        uint seizeTokens
    ) external virtual;

    function transferAllowed(
        address lToken,
        address src,
        address dst,
        uint transferTokens
    ) external virtual returns (uint);

    function transferVerify(
        address lToken,
        address src,
        address dst,
        uint transferTokens
    ) external virtual;

    /*** Liquidity/Liquidation Calculations ***/

    function liquidateCalculateSeizeTokens(
        address lTokenBorrowed,
        address lTokenCollateral,
        uint repayAmount
    ) external view virtual returns (uint, uint);
}
