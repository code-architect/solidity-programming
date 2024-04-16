// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ACL
{
    enum Role {None, Voter, Admin}
    mapping(address => Role) public roles;

    event RoleGranted(address indexed addr, Role role);
    event RoleRevoked(address indexed addr, Role role);

    //===================================================== Helper and Modifirers ===========================================================//
    function hasRole(address _addr, Role _role) public view returns(bool)
    {
        return roles[_addr] == _role;
    }

    modifier onlyRole(Role _role)
    {
        require(hasRole(msg.sender, _role), "You dont have permission");
        _;
    }
    //===================================================== ===================== ===========================================================//

    constructor(address _admin) 
    {
        roles[_admin] = Role.Admin;
    }


    // Grant access of a role if you are admin
    function grantRole(address _address, Role _role) public onlyRole(Role.Admin)
    {
        roles[_address] = _role;
        emit RoleGranted(_address, _role);
    }

    // Revoke access of a role if you are admin
    function revokeRole(address _address) public onlyRole(Role.Admin)
    {
        Role _role = roles[_address];
        roles[_address] = Role.None;
        emit RoleRevoked(_address, _role);
    }
}

contract VotingSystem is ACL
{
    // represent a candidate
    struct Candidate
    {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter
    {
        uint id;
        string name;
        address _address;
        bool voted;
    }

    event VoteGiven(address _voterAddress, uint timestamp);
    event CandidateAdded(uint id, string name);
    event VoterAdded(uint id, string _name, address _address);

    Candidate[] public candidates;
    Voter[] public voters;

    // Mapping to keep track of addresses that have voted
    mapping(address => bool) public hasVoted;

    //===================================================== Helper and Modifirers ===========================================================//
    function voterHasVoted(address _voterAddress) public view returns (bool) 
    {
        return hasVoted[_voterAddress];
    }

    /**
    * @notice Add vote, only voter can add vote, after adding emit event VoteGiven
    * @param _voterAddress The address of the voter
    */
    function voteHasGivenVote(address _voterAddress) internal 
    {
        hasVoted[_voterAddress] = true;
    }
    
    //===================================================== ********************* ===========================================================//
    

    constructor(address _admin) ACL(_admin) public {}

         
    /**
    * @notice Add candidates, only admin can add candidates, after adding emit event CandidateAdded
    * @param _name The name of the candidate
    */
    function addCandidate(string memory _name) public onlyRole(Role.Admin)
    {
        candidates.push(Candidate(candidates.length, _name, 0));
        emit CandidateAdded(candidates.length, _name);
    }
    

    /**
    * @notice Get the number of total candidates
    */
    function getCandidatesCount() public view returns(uint)
    {
        return candidates.length;
    }


    /**
    * @notice Register the voter and grant voter role, only admin can register voter, after registering emit event VoterAdded
    * @param _name The name of the voter
    * @param _address The address of the voter
    */
    function registerVoter(string memory _name, address _address) public onlyRole(Role.Admin)
    {
        voters.push(Voter(voters.length, _name, _address, false));
        grantRole(_address, Role.Voter);
        emit VoterAdded(voters.length, _name, _address);
        
    }


    /**
    * @notice Give vote to a candidate, only a registered voter can give vote
    * @param _candidateId The id of the candidate
    */
    function giveVote(uint _candidateId) public onlyRole(Role.Voter)
    {
        require(voterHasVoted(msg.sender), "You have already voted");
        candidates[_candidateId].voteCount++;
        voteHasGivenVote(msg.sender);
        emit VoteGiven(msg.sender, block.timestamp);
    }


    /**
    * @notice Get the winner of the election, only admin can determine the winner
    */
    function countWinner() public view onlyRole(Role.Admin) returns(string memory winnerName)
    {
        require(candidates.length > 0, "No candidate avaliable");

        uint maxVote = 0;
        uint winnerIndex;

        for(uint i = 0; i < candidates.length;i ++)
        {
            if(candidates[i].voteCount > maxVote)
            {
                maxVote = candidates[i].voteCount;
                winnerIndex = i;
            }
        }
        return winnerName = candidates[winnerIndex].name;
    }


    /**
    * @notice Reset the voting system, only admin can reset 
    */
    function reset() public onlyRole(Role.Admin) 
    {
        // Reset vote counts for all candidates
        for (uint i = 0; i < candidates.length; i++) {
            candidates[i].voteCount = 0;
        }

        // Clear the list of voters who have voted
        for (uint i = 0; i < voters.length; i++) {
            hasVoted[voters[i]._address] = false;
        }
        delete candidates;
    }
}

/**
ISSUES
Gas Limit Exceedance: If the number of candidates or voters becomes very large, it could result in the contract exceeding the gas limit 
when executing functions like reset or countWinner.
Resolution: Implement pagination or batch processing techniques to handle large datasets more efficiently.
Additionally, consider optimizing storage and computation to reduce gas costs.

Integer Overflow: The contract uses unsigned integers to store the vote counts of candidates. If a candidate receives an excessively high 
number of votes, it could cause an integer overflow, potentially leading to incorrect results.
Resolution: Implement checks to prevent integer overflow, such as using SafeMath library for arithmetic operations or using a different 
data type that can handle larger numbers.

SCOPE
1. You can set a time limit
Answer:
uint256 constant MAX_CANDIDATES = 10;
and can add the given require in the add candidate fuynction which will limit it
require(candidates.length < MAX_CANDIDATES, "Maximum number of candidates reached");

*/