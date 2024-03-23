// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CircutBreaker
{
    address public owner;
    bool public paused;

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whenNotPaused()
    {
        require(!paused, "Contract is paused");
        _;
    }

    modifier whenPaused()
    {
        require(paused, "Contract is not paused");
        _;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function withdraw() external onlyOwner whenPaused {
        // Withdraw funds from the contract
        // Example: owner.transfer(address(this).balance);
    }

    function someFunction() external whenNotPaused {
        // Some functionality that should only execute when the contract is not paused
    }
}