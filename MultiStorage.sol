//SPDX-License-Identifier:MIT
pragma solidity ^0.8.8;

contract MultiStorage {

    struct People {
        uint256 favNum;
        string name;
    }

// Array are defined by putting square brackets near the type
    // People[] public people; 
// this is an dynamic array if we add a value inside square brackets we can make static array
// People[3]

// Mappings
// Mappings are similar to dictornary in programming
    mapping(string => uint256) public nameToFavNum;

// EVM can access  and store information in six places
// stack,memory,storage,calldata,code,logs
// Memory and Calldata are temporary variables that are lost after the execution of the funtion
// while storage wil hold the data even after the funtion

// The main difference between memory and calldata are the variable declared with calldata cannot be modified
// while memory can be modified eg: here _name can be reassigned while if calldata is used it cannot be reassigned

// The need of memory ; struct,mappings,arrary need to be specified their lifetime in a funtion
// since string is an array we need to specify its lifetime is only for this funtion
// Even though we cannot add storage here because solidity knows it only uses the variable inside this function

    function addPerson(string memory _name, uint256 _favNum) public {
        //people.push(People(_favNum,_name));
        nameToFavNum[_name] = _favNum;
    }    

}