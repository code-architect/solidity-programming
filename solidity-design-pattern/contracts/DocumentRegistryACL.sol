// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract ACL {

    // Role definition
    enum Role { None, User, Admin }

    // Mapping of addresses to roles
    mapping(address => Role) private roles;

    // Event emitted when a role is granted
    event RoleGranted(address indexed addr, Role role);

    // Event emitted when a role is revoked
    event RoleRevoked(address indexed addr, Role role);

    // Modifier to restrict function access to specific roles
    modifier onlyRole(Role role) {
        require(hasRole(msg.sender, role), "No permission to perform this action");
        _;
    }

    constructor(address _admin) {
        roles[_admin] = Role.Admin; // Assign admin role to the deployer address
        emit RoleGranted(_admin, Role.Admin);
    }

    // Grant a role to an address
    function grantRole(address _addr, Role _role) public onlyRole(Role.Admin) {
        roles[_addr] = _role;
        emit RoleGranted(_addr, _role);
    }

    // Revoke a role from an address
    function revokeRole(address _addr, Role _role) public onlyRole(Role.Admin) {
        roles[_addr] = Role.None;
        emit RoleRevoked(_addr, _role);
    }

    // Check if an address has a specific role
    function hasRole(address _addr, Role _role) public view returns (bool) {
        return roles[_addr] == _role;
    }
}

contract DocumentRegistry is ACL
{
    struct Document 
    {
        address owner;
        string content;
    }

    mapping(uint => Document) private documents;
    uint private nextDocumentId = 1;

    constructor(address _admin) ACL(_admin) {}

    function createDocument(string memory _IPFSHash) public onlyRole(Role.User) returns (uint)
    {
        uint documentId = nextDocumentId++;
        documents[documentId] = Document(msg.sender, _IPFSHash);
        return documentId;
    }

    function updateDocument(uint _documentId, string memory _newIPFSHash) public  onlyRole(Role.User) 
    {
        require(msg.sender == documents[_documentId].owner, "Only the document owner can update the document");
        documents[_documentId].content = _newIPFSHash;
    }

    function getDocumentContent(uint _documentId) public view returns (string memory) {
        return documents[_documentId].content;
    }
}