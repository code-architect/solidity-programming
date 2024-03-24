// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding 
{
    address public owner;
    uint public fundingGoal;
    uint public totalFunds;
    mapping(address => uint) public contributions;
    mapping(address => bool) public backers;

    constructor(uint256 _goal) 
    {
        owner = msg.sender;
        fundingGoal = _goal;
    }

    modifier onlyOwner() 
    {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyBacker() 
    {
        require(backers[msg.sender], "Only backers can call this function");
        _;
    }

    function contribute() external payable 
    {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
        backers[msg.sender] = true;
    }

    function withdrawFunds() external onlyOwner 
    {
        require(totalFunds >= fundingGoal, "Funding goal not reached yet");
        payable(owner).transfer(totalFunds);
        totalFunds = 0;
    }

    function withdrawContribution() external onlyBacker 
    {
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contribution to withdraw");
        contributions[msg.sender] = 0;
        backers[msg.sender] = false;
        totalFunds -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getRefund() external 
    {
        require(!backers[msg.sender], "Backers cannot request refund");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contribution to refund");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
/**
Deploy the contract with the desired funding goal.
Users contribute funds using the contribute function.
Once the funding goal is reached, the owner can call withdrawFunds to withdraw the funds.
If the funding goal is not reached, backers can call withdrawContribution to withdraw their contributions.
Non-backers can call getRefund to request a refund of their contributions.
*/