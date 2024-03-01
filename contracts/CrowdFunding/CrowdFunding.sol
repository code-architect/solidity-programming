// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding
{
    mapping (address => uint) public contributors;
    address public admin;
    uint public numberOfContributors;
    uint public minimumContribution;
    uint public deadline; // timestamp
    uint public goal;
    uint public raisedAmount;

    constructor(uint _goal, uint _deadline) 
    {
        goal = _goal;
        deadline = block.timestamp + _deadline;
    }
}