// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BankApp
{
    // owner
    address public owner;

    constructor() 
    {
        owner = msg.sender;
    }

    // user balance
    mapping(address => uint) private userBalance;

    // deposit
    function deposit() public payable
    {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        userBalance[msg.sender] += msg.value;
    }

    // withdraw
    function withdrawl(uint amount) public 
    {
        require(amount <= userBalance[msg.sender], "You do not have sufficient  balance");        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Amount Transfer failed");
        userBalance[msg.sender] -= amount;
    }

    // balance
    function viewBalance() public view returns(uint)
    {
        return userBalance[msg.sender];
    }

    // change account balance
    function creditOwner(address account, uint amount) public 
    {
        require(msg.sender == owner, "You do not have the permissions. Only te owner can change the balance");
        require(amount > 0, "Deposit amount must be greater than 0");
        userBalance[account] += amount;
    }
}

