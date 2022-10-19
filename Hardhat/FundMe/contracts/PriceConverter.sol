//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function convert(uint256 eth, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 price = getPrice(priceFeed);
        uint256 ethWorth = (price * eth) / 1e18;
        return ethWorth;
    }

    function getPrice(AggregatorV3Interface priceFeed)
        private
        view
        returns (uint256)
    {
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint256(price) * 1e10;
    }
}
