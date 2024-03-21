// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

abstract contract ACL
{
    // role define
    enum Role {None, User, Buyer, Seller, Arbiter}

    // map address with roles
    mapping(address => Role) public roles;

    //event role granted
    event RoleGranted(address _address, Role _role);
    // event role revoked
    event RoleRevoked(address _address, Role _role);
    
    // Modifier to restrict function access to specific roles
    modifier onlyRole(Role _role)
    {
        require(roles[msg.sender] == _role, "You do not have permission");
        _;
    }

     constructor(address _admin) {
        roles[_admin] = Role.Arbiter; // Assign admin role to the deployer address
    }

    // Grant a role to an address (only Admin)
    function roleGranted(address _address, Role _role) public onlyRole(Role.Arbiter)
    {
        roles[_address] = _role;
        emit RoleGranted(_address, _role);
    }
    // Revoke a role from an address (only Admin)
    function roleRevoked(address _address) public onlyRole(Role.Arbiter)
    {
        Role onldRole = roles[_address];
        roles[_address] = Role.None;
        emit RoleRevoked(_address, onldRole);
    }

    // Check if an address has a specific role
    function hasRole(address _addr, Role _role) public view returns(bool)
    {
        return roles[_addr] == _role;
    }
}

contract Escrow is ACL
{
    address payable public buyer;
    address payable public seller;
    address public arbiter;
    uint public value;
    enum State { Created, Funded, Delivered, Completed, Dispute } // Escrow states
    State public currentState;

    constructor(address payable _buyer, address payable _seller, address _arbiter, uint _value) ACL(_arbiter) public 
    {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        value = _value;
        currentState = State.Created; // Start in Created state

        // grant roles based on constructor arguments
        roles[_buyer] = Role.Buyer;
        roles[_seller] = Role.Seller;
    }

    modifier onlyState(State _state)
    {
        require(currentState == _state, "Invalid escrow state for this action");
        _;
    }

    // Buyer deposits funds into escrow (only Buyer)
    function deposite() public payable onlyRole(Role.Buyer) onlyState(State.Created)
    {
        require(msg.value == value, "Incorrect deposit amount");
        currentState = State.Funded;
    }

    // Seller confirms receiving product/service and withdraws funds (only Seller)
    function confirmRelease() public onlyRole(Role.Seller) onlyState(State.Funded) 
    {
        payable(seller).transfer(address(this).balance);
        currentState = State.Completed;
    }

    // Buyer initiates dispute resolution (only Buyer and in Funded state)
    function dispute() public onlyRole(Role.Buyer) onlyState(State.Funded) {
        currentState = State.Dispute; // Transition to Dispute state
        // Implement dispute resolution logic with potential arbiter involvement
    }

    // Arbiter (if set) can finalize the escrow with payout to seller (only Arbiter and in Dispute state)
    function arbiterRelease() public onlyRole(Role.Arbiter) onlyState(State.Dispute) {
        payable(seller).transfer(address(this).balance);
        currentState = State.Completed; // Transition to Completed state
    }

    // Arbiter (if set) can refund the buyer (only Arbiter and in Dispute state)
    function arbiterRefund() public onlyRole(Role.Arbiter) onlyState(State.Dispute) {
        payable(buyer).transfer(address(this).balance);
        currentState = State.Completed; // Transition to Completed state
    }

    // Fallback function to handle accidental ETH transfers
    fallback() external payable {}

    receive() external payable { }
}