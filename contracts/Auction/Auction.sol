// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Auction 
{
    address payable public owner;
    uint startBlock;
    uint endBlock;
    string public ipfsHash;
    enum State {Started, Running, Ended, Canceled}
    State public auctionState;

    uint public highestBindingnBid;
    address payable public highetBidder;

    mapping (address => uint) public bids;

    uint bidIncrement;

    constructor() 
    {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320;  // the auction will run for a week and every 15 second a nw blockis being minined! dot the math
        ipfsHash = "";
        bidIncrement = 100;
    }

    //===================================================== Modifier and helpers Starts ==================================================================
    modifier notOwner()
    {
        require(msg.sender != owner, "You are not allowed to increase the bid");
        _;
    }

    modifier afterStart()
    {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd()
    {
        require(block.number <= endBlock);
        _;
    }

    function min(uint a, uint b) pure internal returns (uint)
    {
        if(a <= b)
        {
            return a;
        }else {
            return b;
        }
    }

    //====================================================== Modifier Ends ===================================================================
    function placeBid() public payable notOwner afterStart beforeEnd 
    {
        require(auctionState == State.Running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingnBid);

        bids[msg.sender] = currentBid;
        if(currentBid <= bids[highetBidder])
        {
            highestBindingnBid = Math.min(currentBid + bidIncrement, bids[highetBidder]);
        }
    }
}