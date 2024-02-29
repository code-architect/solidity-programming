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

    constructor(address eoa) 
    {
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320;  // the auction will run for a week and every 15 second a nw blockis being minined! dot the math
        ipfsHash = "";
        bidIncrement = 1000000000000000000;
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

    modifier onlyOwner()
    {
        require(msg.sender == owner);
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
    
    function cancelAuction() public onlyOwner
    {
        auctionState = State.Canceled;
    }


    function finalizeAuction() public
    {
        require(auctionState == State.Canceled || block.number >endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if(auctionState == State.Canceled) // auction was canceled
        {
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }else { // auction ended not canceled
            if(msg.sender == owner) // the owner
            {
                recipient = owner;
                value = highestBindingnBid;
            }else { // this is a bidder who request his own funds
                if(msg.sender == highetBidder)
                {
                    recipient = highetBidder;
                    value = bids[highetBidder] - highestBindingnBid;
                }else{
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        bids[recipient] = 0;
        recipient.transfer(value);
    }
    
    
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
        }else{
            highestBindingnBid = min(currentBid, bids[highetBidder] + bidIncrement);
            highetBidder = payable(msg.sender);
        }
    }    
}


contract AuctionCreator
{
    Auction[] public auctions;
    function createAuction() public 
    {
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}
