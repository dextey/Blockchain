//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

contract SimpleStorage {
    uint256 storeValue;

    function store(uint256 value) public {
        storeValue = value;
    }

    function retrieve() public view returns (uint256) {
        return storeValue;
    }
}
