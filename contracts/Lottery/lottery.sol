// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery 
{
    address payable[] public players;
    address internal manager;

    constructor() 
    {
        manager = msg.sender;
    }

    receive() external payable { 
        require(msg.sender != manager, "manager cannot bet");
        require(msg.value == 20, "You have to put exactly 20 Wei");
        require(!checkAddressExists(msg.sender), "You have already applied"); // Negate the condition
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint)
    {
        require(msg.sender == manager, "You are not allowed to see the balance");
        return address(this).balance;
    }

    function getAllPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function checkAddressExists(address newPlayer) internal returns (bool) {
    for (uint i = 0; i < players.length; i++) {
        if (players[i] == newPlayer) {
            return true;
        }
    }
        return false;
    }
}