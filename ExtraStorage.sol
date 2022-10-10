//SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

import "./MultiStorage.sol";

// Inheritence in Solidity is using is keyword
// Extrastorage is a child of multistorage we it can have all properties of multistorage
contract ExtraStorage is MultiStorage{

    // If we need to override a parent funtion like addperson in multistorage
    // we need to use override keyword as shown below
    // And a function is overrideable only if it is a virtual funtion
    // we need to add keyword virtual to the addPerson function in Multistorage contract as shown
    // Multistorage.sol -- example

    // function addPerson(string memory _name, uint256 _favNum) public virtual {
    // people.push(People(_favNum,_name));
    //   nameToFavNum[_name] = _favNum; }

    // only then we will be able to overide the funtion when inherited
    function addPerson(string memory _name,uint256 _favNum) public override {
        nameToFavNum[_name] = _favNum + 5;
    }

    // In order for this contract to work change multistorage.sol as code given above

}