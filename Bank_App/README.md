# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```


Here's a structured breakdown of the provided code:

1. Common Components:

License:
// SPDX-License-Identifier: UNLICENSED
Solidity Version:
pragma solidity ^0.8.0;
2. Reusable Elements:

Interface:
IERC20 interface defining standard functions for ERC20 tokens
Library:
SafeMath library providing safe arithmetic operations to prevent overflow and underflow
Contract:
Context contract offering basic context functions like _msgSender() and _msgData()
Contract:
Ownable contract implementing ownership control features
3. Main Contract:

Contract:
TutToken contract representing the core token implementation, inheriting from Context, IERC20, and Ownable
4. Structure of TutToken Contract:

State Variables:
_balances: Mapping to store token balances for each address
_allowances: Mapping to track approved spending amounts for different spenders
_totalSupply: Total token supply
_decimals: Number of decimals for token precision
_symbol: Token symbol (e.g., "TUT")
_name: Token name (e.g., "TutToken")
Constructor:
Initializes token properties and assigns initial total supply to the deploying address
Functions:
getOwner(): Inherited from Ownable, returns the contract owner
decimals(), symbol(), name(), totalSupply(), balanceOf(): Implement the core ERC20 functions
transfer(): Transfers tokens between accounts
allowance(), approve(), transferFrom(): Manage token allowances for third-party spending
increaseAllowance(), decreaseAllowance(): Adjust allowances
burn(): Destroys tokens
burnFrom(): Destroys tokens from another user's account (requires allowance)
Internal Functions:
_transfer(), _burn(), _approve(): Helper functions to perform core operations internally
_burnFrom(): Combines burning and allowance adjustments for burnFrom()
5. Inheritance and Libraries:

TutToken inherits from Context, IERC20, and Ownable to leverage their features and functionality.
SafeMath library is used for secure arithmetic operations within the contract.