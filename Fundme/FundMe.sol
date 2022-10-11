//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

//Interfaces 
// interface are funciton declaration without defenition
// Its gives the ABI for the contract

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 minimumUSD = 50 * 1e18;
    // smartcontracts can also able to hold funds just like wallets
    function fund() public payable {
        //msg.value is the amount sent to function fund
        //require keyword is like if statement in programming
        // that is if the condition is not met the revert with the following error
        require(getEthUsd(msg.value) >= minimumUSD,"You need to send atleast 50 $ worth ETH"); // 1e18 = 1 * 10 ** 18

        //revert means undo any action before and send the remaining gas back


    }

    function getPrice() public view returns(uint256) {
        //Address = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int price,,,) = priceFeed.latestRoundData();
        //price is given with 8 additional decimals so we need to multipy with 10e10 to make 18 decimals
        return uint256(price * 1e10);
    }

    function getEthUsd(uint256 eth) public view returns(uint256){
        uint256 price = getPrice();
        uint256 ethWorth = (price *  eth)/1e18;
        return ethWorth;
    }

    // function to withdraw funds
    // function withdraw() {}
}