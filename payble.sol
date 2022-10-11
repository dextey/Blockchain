//SPDX-License-Identifier:MIT

pragma solidity 0.8.8;

contract Payable {

    address payable owner;

    constructor() payable{
        owner = msg.sender;
    }

    function deposit() public payable {}

    function withdraw() public  {
      require(msg.sender==owner,"This function can only be called by ownwe of this contract");
      uint amount = address(this).balance;
      (bool success,) = owner.call{value:amount}("");
      require(success,"Transfer Unsuccessfull");
    }

}