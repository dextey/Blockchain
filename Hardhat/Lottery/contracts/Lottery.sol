// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
//Enter a lottery by paying some amount
// Pick a random winner
// Winner to selected automatically within certain time

error LuckyDraw_NotEnoughETHentered();

contract LuckyDraw {
    uint256 immutable entranceFee;

    address payable[] private players;

    constructor(uint256 _entranceFee) {
        entranceFee = _entranceFee;
    }

    function enterLuckyDraw() public payable {
        if (msg.value < entranceFee) {
            revert LuckyDraw_NotEnoughETHentered();
        }
        players.push(payable(msg.sender));
    }

    function getEntranceFee() public view returns (uint256) {
        return entranceFee;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
