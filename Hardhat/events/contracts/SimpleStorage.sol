// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleStorage {
    uint256 favNum;

    event storedNumber(
        uint256 indexed oldNumber,
        uint256 indexed newNumber,
        uint256 addedNumber,
        address sender
    );

    function store(uint256 _favNum) public {
        favNum = _favNum;
        emit storedNumber(favNum, _favNum, favNum + _favNum, msg.sender);
    }

    function show() public view returns (uint256) {
        return favNum;
    }
}
