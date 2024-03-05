// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
  // Standard ERC-20 interface.
  // function allowance(address owner, address spender) external view returns (uint256);
  // function approve(address spender, uint256 value) external returns (bool);
  // function transferFrom(address from, address to, uint256 value) external returns (bool);

  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);  
  function transfer(address to, uint256 value) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint tokens);
  // Extension of ERC-20 interface to support supply adjustment.
//   function mint(address to, uint256 value) external returns (bool);
//   function burn(address from, uint256 value) external returns (bool);
}

contract CACrypto is ERC20Interface
{
    string public name = "CACrypto";
    string public symbol = "CAC";
    uint public decimals = 0; //18 by default
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    constructor() 
    {
      totalSupply = 1000000;
      founder = msg.sender;
      balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) external view override returns (uint256 balance)
    {
      return balances[tokenOwner];
    }

    function transfer(address to, uint256 value) external override returns (bool success)
    {
      require(balances[msg.sender] >= value);
      balances[to] += value;
      balances[msg.sender] -= value;
      emit Transfer(msg.sender, to, value);
      return true;
    }

}