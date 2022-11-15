// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
//Enter a lottery by paying some amount
// Pick a random winner
// Winner to selected automatically within certain time

error LuckyDraw_NotEnoughETHentered();
error LuckyDraw_TransferFailed();
error LuckyDraw_NotOpen();
error LuckyDraw_NotUpkeepNeeded(
    uint256 currentBalance,
    uint256 NumberOfPlayers,
    uint256 luckydrawState
);

contract LuckyDraw is VRFConsumerBaseV2, KeeperCompatibleInterface {
    enum LuckyDrawState {
        OPEN,
        CALCULATING
    }

    uint256 immutable entranceFee;
    address payable[] private players;
    VRFCoordinatorV2Interface private immutable vrfCoordinator;
    bytes32 private immutable gaslane;
    uint64 private immutable subscriptionId;
    uint16 private constant MINIMUM_CONFIRMATION = 3;
    uint32 private immutable gaslimit;
    uint16 private constant NUM_WORDS = 1;

    address private recentWinner;
    LuckyDrawState private luckydrawState;
    uint256 private lastTimeStamp;
    uint256 private immutable interval;
    /* EVENTS */

    event LuckyDrawEntry(address indexed player);
    event RequestedWinner(uint256 indexed requestId);
    event winnerPicked(address winner);

    /* EVENTS*/

    constructor(
        address vrfCoordinatorV2,
        uint256 _entranceFee,
        bytes32 _gaslane,
        uint64 _subscriptionId,
        uint32 _gaslimit,
        uint256 _interval
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        entranceFee = _entranceFee;
        vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        gaslane = _gaslane;
        subscriptionId = _subscriptionId;
        gaslimit = _gaslimit;
        luckydrawState = LuckyDrawState.OPEN;
        lastTimeStamp = block.timestamp;
        interval = _interval;
    }

    function enterLuckyDraw() public payable {
        if (msg.value < entranceFee) {
            revert LuckyDraw_NotEnoughETHentered();
        }
        if (luckydrawState != LuckyDrawState.OPEN) {
            revert LuckyDraw_NotOpen();
        }
        players.push(payable(msg.sender));
        emit LuckyDrawEntry(msg.sender);
    }

    /* Chainlink kee[ers 
        check upkeep function define what all condition must be statisfied to run following code/function
        at certain intercal of time
        Here we must ensure : time, atleast 2 players, balace of contract, is subscription is funded with link
        IMP (enum) Is lottery open/closed  
    */
    function checkUpkeep(
        bytes memory /*checkdata*/
    )
        public
        override
        returns (
            bool upkeepNeeded,
            bytes memory /*bytes memory performData*/
        )
    {
        bool isOpen = (LuckyDrawState.OPEN == luckydrawState);
        bool timePassed = ((block.timestamp - lastTimeStamp) > interval);
        bool hasPlayers = (players.length > 1);
        bool hasBalance = address(this).balance > 0;

        upkeepNeeded = (isOpen && timePassed && hasPlayers && hasBalance);
        return (upkeepNeeded, "0x0"); // can we comment this out?
    }

    function performUpkeep(
        bytes calldata /*perform Data*/
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert LuckyDraw_NotUpkeepNeeded(
                address(this).balance,
                players.length,
                uint256(luckydrawState)
            );
        }
        // Request random number
        // Do somthing with it
        // chainlink vrf is a 2 transaction
        luckydrawState = LuckyDrawState.CALCULATING;
        uint256 requestId = vrfCoordinator.requestRandomWords(
            gaslane,
            subscriptionId,
            MINIMUM_CONFIRMATION,
            gaslimit,
            NUM_WORDS
        );
        emit RequestedWinner(requestId);
    }

    function fulfillRandomWords(
        uint256, /* request ID*/
        uint256[] memory randomWords
    ) internal override {
        uint256 indexOfWinner = randomWords[0] % players.length;
        recentWinner = players[indexOfWinner];

        luckydrawState = LuckyDrawState.OPEN;
        players = new address payable[](0);
        lastTimeStamp = block.timestamp;

        (bool success, ) = payable(recentWinner).call{value: address(this).balance}("");
        if (!success) {
            revert LuckyDraw_TransferFailed();
        }

        emit winnerPicked(recentWinner);
    }

    // Pure / view funtions

    function getEntranceFee() public view returns (uint256) {
        return entranceFee;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function getRecentWinner() public view returns (address) {
        return recentWinner;
    }

    function getLuckyDrawState() public view returns (LuckyDrawState) {
        return luckydrawState;
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return players.length;
    }

    function getLatestTimestamp() public view returns (uint256) {
        return lastTimeStamp;
    }
}
