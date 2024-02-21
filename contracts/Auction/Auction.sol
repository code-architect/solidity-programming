// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

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
}