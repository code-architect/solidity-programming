// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Address of the authorized account that can withdraw funds
    
contract DepositContract {
    mapping(address => uint) public deposits;
    address[] public depositors;

    // Function to deposit funds
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        deposits[msg.sender] += msg.value;
        
        // Add the depositor to the list if they haven't deposited before
        if (deposits[msg.sender] == msg.value) {
            depositors.push(msg.sender);
        }
    }

    // Function to reset all values in the mapping to zero
    function resetDeposits() external {
        for (uint i = 0; i < depositors.length; i++) {
            deposits[depositors[i]] = 0;
        }
    }

    // Function to get the number of depositors
    function getDepositorsCount() external view returns (uint) {
        return depositors.length;
    }

    // Function to get the address of a depositor at a specific index
    function getDepositorAtIndex(uint index) external view returns (address) {
        require(index < depositors.length, "Index out of range");
        return depositors[index];
    }
}
