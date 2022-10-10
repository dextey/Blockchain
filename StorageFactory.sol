//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

// The ability of the smart contracts to seamlessly
// interact with each other is known as composability
// Smart contract are composible since they can interact with other contracts

import "./MultiStorage.sol";

contract StorageFactory {

    MultiStorage[]  multiStorageList;

    // function it create contract multistorage
    function createMultiStorageContract() public {
        multiStorageList.push(new MultiStorage());
    }

    function sfStore(uint256 _contractIndex, string memory _name,uint256 _favNum) public {
    // In order to interact with a contract we always need address and ABI
    // ABI - Application binary Interface
        //If multistorageList is a list of type address we need to wrap
        // multiStorageList[_contractIndex] with MultiStorage(multiStorageList[_contractIndex]) to get ABI
        //Since multistorageList is a list of type MultiStorage contracts we can get both address and abi
        //using below code because we get back a mulitstorage object
        MultiStorage multiStorage = multiStorageList[_contractIndex];
        multiStorage.addPerson(_name,_favNum);
    }

    function sfGet(uint256 _contractIndex,string memory _name) public view returns(uint256){
        MultiStorage multiStorage = multiStorageList[_contractIndex];
        return multiStorage.retrieve(_name);
    }    

}