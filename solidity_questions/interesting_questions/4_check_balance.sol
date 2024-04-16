// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//to check the balance of a given address:
contract AddressBalanceChecker {

  // Function to check the balance of an address
  function getBalance(address targetAddress) public view returns (uint) 
  {
    return targetAddress.balance;
  }
}