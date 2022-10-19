//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    uint256 minimumUSD = 50 * 1e18;

    //address array for storing addresses of funders
    address[] public funders;
    mapping(address => uint256) addressFunded;

    // smartcontracts can also able to hold funds just like wallets with use of payable
    function fund() public payable {
        //msg.value is the amount sent to function fund
        //require keyword is like if statement in programming
        // that is if the condition is not met the revert with the following error
        require(
            msg.value.getEthPrice() >= minimumUSD,
            "You need to send atleast 50 $ worth ETH"
        ); // 1e18 = 1 * 10 ** 18
        //revert means undo any action before and send the remaining gas back
        funders.push(msg.sender); // msg.sender is the address of sender
        addressFunded[msg.sender] = msg.value;
    }

    // function to withdraw funds
    // onlyOwner is a modifier which is call before running whats inside the function
    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; ++i) {
            address funder = funders[i];
            addressFunded[funder] = 0;
        }

        //Reseting array
        funders = new address[](0);

        // three diff to send
        //transfer,send,call
        // transefer method
        // payable(msg.sender).transfer(address(this).balance);
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Transfer error");
    }

    // modifers
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized call");
        _; //this underscore represent doing rest of the code
        // if the underscore is above require then require code
        // is only run after the funtion is executed
    }
}
