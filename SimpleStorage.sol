//SPDX-License-Identifier:MIT
pragma solidity ^0.8.8;
// this specifies the  compiler that should be  used

// contract is similar to classes in programming
contract SimpleStorage {
    //solidty contain boolean, strng, uint, int, address, bytes 
    
    uint256 favNum;
    // string favtext = "some text";
    // address myAddress = 0x2483F38338202D83;

    // Function in solidity
    function store(uint256 value) public {
        favNum = value;
    }


// VIEW and PURE keywords
    // View and pure funtion doesn't allow to change state inside blockchain
    // It only allows to read data
    // But Pure function does not even allow to change state in the contract
    // pure funciton as mainly used to do specific tasks such as math funtions which are used frequently
    function showFav() public view returns(uint256) {
        return favNum;
    }

// Every time we call  the store funtion a transaction is made
// That is a transaction has to made to change state in the blockchain
// but to read the data from blockchain no transaction is needed

// for every transaction some fee has to given
// depending upon the workload of the funtion gas fee also increases
}
// Every contract has an address like wallet address
// 0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B

