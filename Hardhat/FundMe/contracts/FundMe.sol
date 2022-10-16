//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    address owner;
    uint256 minimumUsd = 50 * 1e18;
    mapping(address => uint256) addressFunded;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.convert() >= minimumUsd,
            "Send atleast 50$ worth ethereum"
        );

        addressFunded[msg.sender] = msg.value;
    }

    function withDraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "An error occured while withdrawing funds");
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can withdraw funds");
        _;
    }
}
