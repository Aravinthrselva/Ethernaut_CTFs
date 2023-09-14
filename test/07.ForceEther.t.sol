// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract forceEther {

    constructor (address payable target) payable {
        require(msg.value >0);
        selfdestruct(target);
    }
}