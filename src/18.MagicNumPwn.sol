//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// walkthru
// https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2
contract MagicNumPwn {

constructor(MagicNum magicContract) {
    bytes memory bytecode = hex"600a600c600039600a6000f3602a60005260206000f3";
    bytes32 salt = 0;
    address solver;

    assembly {
        // create2(value, offset, size)
        // value- amount of ether to send to the contract
        // offset- the pointer in memory where the code is stored - 
        // for dynamic arrays the first 32 bytes stores the length of the array - so we need to skip the first 32bytes to get to the code (0x20 in hex)
        // size - size of the code 
        solver := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
    }
    
    magicContract.setSolver(solver);
}


/* 
Runtime Opcodes  Part 1
Returning values is handled by the RETURN opcode, which takes in two arguments:

p: the position where your value is stored in memory, i.e. 0x0, 0x40, 0x50 (see figure). Let’s arbitrarily pick the 0x80 slot.
s: the size of your stored data. Recall your value is 32 bytes long (or 0x20 in hex).

1. mstore(p, v)
6042    // v: push1 0x42 (value is 0x42)
6080    // p: push1 0x80 (memory slot is 0x80)
52      // mstore

2. return this the 0x42 value:
6020    // s: push1 0x20 (value is 32 bytes in size)
6080    // p: push1 0x80 (value was stored in slot 0x80)
f3      // return

This resulting opcode sequence should be 604260805260206080f3. 
Your runtime opcode is exactly 10 opcodes and 10 bytes long

*/


/** Initialization Opcodes — PART 2 
 

Copying code from one place to another is handled by the opcode 'codecopy', which takes in 3 arguments:

t: the destination position of the code, in memory. Let’s arbitrarily save the code to the 0x00 position.
f: the current position of the runtime opcodes, 
in reference to the entire bytecode. Remember that f starts after initialization opcodes end. What a chicken and egg problem! This value is currently unknown to you.
s: size of the code, in bytes. Recall that 604260805260206080f3 is 10 bytes long (or 0x0a in hex).

600a    // s: push1 0x0a (10 bytes)
60??    // f: push1 0x?? (current position of runtime opcodes)
6000    // t: push1 0x00 (destination memory index 0)
39      // CODECOPY

Then, return your in-memory runtime opcodes to the EVM:
600a    // s: push1 0x0a (runtime opcode length)
6000    // p: push1 0x00 (access memory index 0)
f3      // return to EVM

Notice that in total, your initialization opcodes take up 12 bytes, or 0x0c spaces.
600a    // s: push1 0x0a (10 bytes)
600c    // f: push1 0x?? (current position of runtime opcodes)
6000    // t: push1 0x00 (destination memory index 0)
39      // CODECOPY


The final sequence is thus:
0x600a600c600039600a6000f3604260805260206080f3

// This will return the no. 42 , irrespective of the function called
*/
}

contract MagicNum {

  address public solver;

  constructor() {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}