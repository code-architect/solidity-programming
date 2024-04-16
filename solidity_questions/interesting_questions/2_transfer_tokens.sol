// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LetsTransfer
{
    // Write a Solidity function to transfer tokens from one address to another.
    
    function transferTokens(address tokenAddress, address addressFrom, address addressTo, uint amount) public 
    {
        IERC20 token = IERC20(tokenAddress); //This function requires the token contract to implement the ERC20 standard

        // Require the 'from' address to have approved this contract to transfer tokens on its behalf (typical ERC20 pattern)
        require(token.allowance(addressFrom, addressTo) >= amount, "Insufficient allowance");
        token.transferFrom(addressFrom, addressTo, amount);
    }
}