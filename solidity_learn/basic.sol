// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloWorld {
    // bool public greet = false;
    // uint public my_num = 11;
    // int public my_new_num = -1;

    // How to check what is the value  
    // int public value_one = type(int).min;
    // int public value_two = type(int).max;

    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}
