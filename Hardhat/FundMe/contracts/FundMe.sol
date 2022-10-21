//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    //immutable variable are similar to constants but can assign it one time
    address immutable i_owner;
    uint256 constant minimumUsd = 50 * 1e18;
    mapping(address => uint256) public s_addressFunded;

    AggregatorV3Interface public s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(
            msg.value.convert(s_priceFeed) >= minimumUsd,
            "Send atleast 50$ worth ethereum"
        );

        s_addressFunded[msg.sender] = msg.value;
    }

    function withDraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "An error occured while withdrawing funds");
    }

    modifier onlyOwner() {
        if (i_owner != msg.sender) revert FundMe__NotOwner();
        _;
    }
}
