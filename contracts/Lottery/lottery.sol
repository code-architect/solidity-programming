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

    function checkAddressExists(address newPlayer) internal view returns (bool) {
    for (uint i = 0; i < players.length; i++) {
        if (players[i] == newPlayer) {
            return true;
        }
    }
        return false;
    }

    function randomNumber() internal view returns (uint)
    {
        require(players.length >= 3, "Not enough players");
        require(msg.sender == manager, "You are not allowed to use the method");
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public
    {
        require(msg.sender == manager, "You are not allowed to use the method");
        require(players.length >= 3, "Not enough players");

        uint rand = randomNumber();
        address payable winner;

        uint index = rand % players.length;
        winner = players[index];

        winner.transfer(getBalance());
    }
   
    
}