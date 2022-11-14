// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
//Enter a lottery by paying some amount
// Pick a random winner
// Winner to selected automatically within certain time

error LuckyDraw_NotEnoughETHentered();

contract LuckyDraw is VRFConsumerBaseV2 {
    uint256 immutable entranceFee;
    address payable[] private players;
    VRFCoordinatorV2Interface private immutable vrfCoordinator;
    bytes32 private immutable gaslane;
    uint64 private immutable subscriptionId;
    uint16 private constant MINIMUM_CONFIRMATION = 3;
    bytes32 private immutable gaslimit;
    /* EVENTS */

    event LuckyDrawEntry(address indexed player);
    event RequestWinner(uint256 indexed requestId);
    /* EVENTS*/

    constructor(address vrfCoordinatorV2,uint256 _entranceFee, bytes32 _gaslane, uint64 _subscriptionId,uint32 _gaslimit)
        VRFConsumerBaseV2(vrfCoordinatorV2)
    {
        entranceFee = _entranceFee;
        vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        gaslane = _gaslane;
        subscriptionId = _subscriptionId;
        gaslimit = _gaslimit
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
        uint256 requestId = vrfCoordinator.requestRandomWords(
            gaslane,
            subscriptionId,
            MINIMUM_CONFIRMATION,
            gaslimit,
            NUM_WORDS
        )
        emit RequestWinner(requestId);
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
