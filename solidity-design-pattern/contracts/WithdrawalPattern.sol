// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WithdrawalPattern 
{
    mapping(address => uint) public balances;
    mapping(address => bool) public allowed;

    function deposit() external payable 
    {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external 
    {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(allowed[msg.sender], "Withdrawals not allowed");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function allowWithdrawal(address account) external {
        require(msg.sender == account || msg.sender == address(this), "Not authorized");
        allowed[account] = true;
    }

    function disallowWithdrawal(address account) external {
        require(msg.sender == account || msg.sender == address(this), "Not authorized");
        allowed[account] = false;
    }
}