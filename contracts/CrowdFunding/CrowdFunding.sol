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

    struct Request
    {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numRequestes;

    modifier onlyAdmin{
        require(msg.sender == admin,"Only admin can call this function");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin 
    {
        Request storage newRequest = requests[numRequestes];
        numRequestes++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    constructor(uint _goal, uint _deadline) 
    {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    function contribute() public payable 
    {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum contribution not met");
        if(contributors[msg.sender] == 0)
        {
            numberOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    receive() external payable 
    {
        contribute();
    }

    function getBalance() public view returns(uint)
    {
        return address(this).balance;
    }

    function getrefund() public 
    {
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributors[msg.sender] > 0, " You have not donated any cash");

        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recipient.transfer(value);

        // the above line can be writen like below
        //payable(msg.sender).transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    function voteRequest(uint _requestNo) public 
    {
        require(contributors[msg.sender] > 0, "You must be a contributor to vote");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false, "You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin
    {
        require(raisedAmount >= goal, "Goan not reached yet");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.completed == false, " The request has complited");
        require(thisRequest.noOfVoters > (numberOfContributors / 2), "Not enough vote to withdraw");

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }
}