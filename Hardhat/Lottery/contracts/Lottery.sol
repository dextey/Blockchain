// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
//Enter a lottery by paying some amount
// Pick a random winner
// Winner to selected automatically within certain time

error LuckyDraw_NotEnoughETHentered();

contract LuckyDraw is VRFConsumerBaseV2 {
    uint256 immutable entranceFee;
    address payable[] private players;

    /* EVENTS */

    event LuckyDrawEntry(address indexed player);

    /* EVENTS*/

    constructor(uint256 _entranceFee, address vrfCoordinatorV2)
        VRFConsumerBaseV2(vrfCoordinatorV2)
    {
        entranceFee = _entranceFee;
    }

    function enterLuckyDraw() public payable {
        if (msg.value < entranceFee) {
            revert LuckyDraw_NotEnoughETHentered();
        }
        players.push(payable(msg.sender));
        emit LuckyDrawEntry(msg.sender);
    }

    function requestRandomWinner() external {
        // Request random number
        // Do somthing with it
        // chainlink vrf is a 2 transaction
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {}

    function getEntranceFee() public view returns (uint256) {
        return entranceFee;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
