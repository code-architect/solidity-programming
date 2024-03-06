// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "../ERC20Token/erc20_token.sol";

contract CACryptoICO is CACrypto
{
    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.001 ether; // 1 eth = 1000 CAC, or 1 CAC =  0.001ETH
    uint public hardCap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800; // 60 seconds/minute * 60 minutes/hour * 24 hours/day * 7 days/week = 604,800 seconds, i.e: ico ends in one week
    uint public tokenTradeStart = saleEnd + 604800;
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    event Invest(address indexed investor, uint value, uint tokens);

    constructor(address payable _deposit) 
    {
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

    modifier onlyAdmin
    {
        require(msg.sender == admin);
        _;
    }

    function halt() public onlyAdmin
    {
        icoState = State.halted;
    }

    function resume() public onlyAdmin
    {
        icoState = State.running;
    }

    function channgeDepositAddress(address payable newDeposit) public onlyAdmin
    {
        deposit = newDeposit;
    }

    function getCurrentSTate() public view returns(State)
    {
        if(icoState == State.halted)
        {
            return State.halted;
        }else if(block.timestamp < saleStart)
        {
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd)
        {
            return State.running;
        }else
        {
            return  State.afterEnd;
        }
    }

    function invest() payable public returns(bool)
    {
        icoState = getCurrentSTate();
        require(icoState == State.running);
        require(msg.value >= minInvestment && msg.value <= maxInvestment);

        raisedAmount += msg.value;
        require(raisedAmount <= hardCap);

        uint tokens = msg.value/tokenPrice;

        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        deposit.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokens);
        return true;
    }

    receive() external payable { 
        invest();
    }
}