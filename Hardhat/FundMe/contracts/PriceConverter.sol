//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function convert(uint256 eth) internal view returns (uint256) {
        uint256 price = getPrice();
        uint256 ethWorth = (price * eth) / 1e18;
        return ethWorth;
    }

    function getPrice() private view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint256(price) * 1e10;
    }
}
