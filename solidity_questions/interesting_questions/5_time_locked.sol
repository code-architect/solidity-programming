// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Write a Solidity function to implement a time-locked contract, which allows funds to be withdrawn only after a certain time has elapsed.
contract TimeLock
{
    address payable public beneficiary;

    uint public locktime;
    uint public lockstart;
    

    // Event to signal a successful withdrawal
    event Withdrawl(address payable _beneficiary, uint amount, uint _locktime);

    // Constructor to set beneficiary and lock time
    constructor(address payable _beneficiary, uint _locktime) public 
    {
        beneficiary = _beneficiary;
        locktime = _locktime;
        lockstart = block.timestamp; // Record the lock start timestamp
    }

    // Function to withdraw funds after the lock time has elapsed
    function withdraw() public 
    {
        // check if lock time has passed
        if(block.timestamp >= lockstart + locktime)
        {
            uint amount = address(this).balance;
            payable(beneficiary).transfer(amount);
            emit Withdrawl(beneficiary, amount, block.timestamp);
        }else{
            revert("Lock time not yet passed");
        }

    }
}