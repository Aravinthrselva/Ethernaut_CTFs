// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/01.Fallback.sol";

contract FallbackTest is Test {

    Fallback fallbackContract;
    address fallbackContractAddr;
    address deployerAddr;

    function setUp() public {
        
    fallbackContract = new Fallback();
    fallbackContractAddr = address(fallbackContract);
    deployerAddr = address(this);
    console.log("Deployer address :", address(this));
    console.log("Address of the deployed fallback contract :", fallbackContractAddr);

    }

    function testFallback() public {
            
        fallbackContract.contribute{value: 101}();
        (bool sent, ) = fallbackContractAddr.call{value : 11}("");
        console.log("bool sent :", sent);
        address fallBackOwner = fallbackContract.owner();
        console.log("fallbackOwner : ", fallBackOwner);
        assertEq((fallBackOwner), deployerAddr);

    
    }
}