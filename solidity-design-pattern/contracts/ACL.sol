// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract ACL
{
    enum Role { None, User, Admin }
    mapping(address => Role) public roles;

    event RoleGranted(address indexed addr, Role role);
    event RoleRevoked(address indexed addr, Role role);

    modifier onlyRole(Role _role)
    {
        require(hasRole(msg.sender, _role), "No permission to perform this action");
        _;
    }

    constructor(address _admin) public {
        roles[_admin] = Role.Admin; // Assign admin role to the deployer address
    }

    // This function allows anyone to check if a given address (_addr) has a specific role (_role). It returns true if the address has the specified role, and false otherwise.
    function hasRole(address _addr, Role _role) public view returns(bool)
    {
        return roles[_addr] == _role;
    }

    function grantRole(address _addr, Role _role) public onlyRole(Role.Admin)
    {
        roles[_addr] = _role;
        emit RoleGranted(_addr, _role);
    }

    function revokeRole(address _addr, Role _role) public onlyRole(Role.Admin)
    {
        roles[_addr] = Role.None;
        emit RoleRevoked(_addr, _role);
    }
}

contract MyContract is ACL 
{
    constructor(address _admin) ACL(_admin) public {}

    function TestFunctionRole() public onlyRole(Role.User) 
    {
        // Function logic only accessible to users
    }

    function someAdminFunction() public onlyRole(Role.Admin) {
    // Function logic only accessible to admins
    }
    
}