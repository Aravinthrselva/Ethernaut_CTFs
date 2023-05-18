// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/00.HelloEthernaut.sol";

contract HelloEthernautTest is Test { 

    HelloEthernaut hello;
    function setUp() public {

    hello = new HelloEthernaut('avantgarde');
    console.log("Address of deployed hello contract : ", address(hello));
    }

    function testPassword() public {
        assertEq(hello.password(), 'avantgarde');
        hello.authenticate('avantgarde');
        assertEq(hello.getCleared(), true);
    }


}


