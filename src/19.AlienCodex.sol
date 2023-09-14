//SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;
//0x925C192397F9cb4073927509d4933E30c97225bc
/*
You've uncovered an Alien contract. Claim ownership to complete the level.

  Things that might help

Understanding how array storage works
Understanding ABI specifications
Using a very underhanded approach
 */

//import '../helpers/Ownable-05.sol';



contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function makeContact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
    codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}