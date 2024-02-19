// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery 
{
    address payable[] public players;
    address public manager;

    constructor() 
    {
        manager = msg.sender;
    }

    receive() external payable { 
        require(msg.sender != manager, " manager cannot bet");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint)
    {        
        return address(this).balance;
    }
}