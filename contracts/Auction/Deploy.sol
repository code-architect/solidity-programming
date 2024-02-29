// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Deploy 
{
    address public ownerA;

    constructor(address eoa) 
    {
        ownerA = eoa;
    }
}

contract Creator 
{
    address public ownerCreator;
    Deploy[] public deployed;

    constructor() {
        ownerCreator = msg.sender;
    }

    function deployOwnerA() public 
    {
        Deploy new_deploy_address = new Deploy(msg.sender);
        deployed.push(new_deploy_address);
    }
    
}