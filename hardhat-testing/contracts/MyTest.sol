// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import hardhat console
import "hardhat/console.sol";

contract MyTest 
{
    uint256 public unlockedTime;
    address payable public owner;

    event Withdrawal(uint256 amount, uint256 timeTaken);

    constructor(uint _unlockedTime) payable
    {
        require(block.timestamp < _unlockedTime, "The time should be in future");
        unlockedTime = _unlockedTime;
        owner = payable(msg.sender);
    }

    function withdraw() public
    {
        require(block.timestamp > unlockedTime, "Wait for the time period to be complited");
        require(msg.sender == owner, "You are not an owner");

        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }
}