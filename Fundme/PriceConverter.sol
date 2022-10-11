//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

//Interfaces 
// interface are funciton declaration without defenition
// Its gives the ABI for the contract
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() public view returns(uint256) {
        //Address = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int price,,,) = priceFeed.latestRoundData();
        //price is given with 8 additional decimals so we need to multipy with 10e10 to make 18 decimals
        return uint256(price * 1e10);
    }

    function getEthPrice(uint256 eth) public view returns(uint256){
        uint256 price = getPrice();
        uint256 ethWorth = (price *  eth)/1e18;
        return ethWorth;
    }

} 