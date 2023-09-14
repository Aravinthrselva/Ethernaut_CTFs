// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/04.Telephone.sol";

contract TelephoneScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new Telephone();
        vm.stopBroadcast();

    }
}
