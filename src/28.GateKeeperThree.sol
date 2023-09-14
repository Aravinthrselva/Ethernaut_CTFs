//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// GK3 contract --  0x02FaA8ab41AEa3a9965262C9e7960FC4e479B65c
contract SimpleTrick {
  GatekeeperThree public target;
  address public trick;
  uint private password = block.timestamp;

  constructor (address payable _target) {
    target = GatekeeperThree(_target);
  }
    
  function checkPassword(uint _password) public returns (bool) {
    if (_password == password) {
      return true;
    }
    password = block.timestamp;                     // Why setting the password again ?
    return false;
  }
    
  function trickInit() public {                     //called by GK3 contract
    trick = address(this);
  }
    
  function trickyTrick() public {                      
    if (address(this) == msg.sender && address(this) != trick) {      // 🚩
      target.getAllowance(password);
    }
  }
}

contract GatekeeperThree {
  address public owner;
  address public entrant;
  bool public allowEntrance;

  SimpleTrick public trick;

  function construct0r() public {
      owner = msg.sender;                             // call constructor to become owner
  }

  modifier gateOne() {
    require(msg.sender == owner);
    require(tx.origin != owner);                        
    _;
  }

  modifier gateTwo() {
    require(allowEntrance == true);
    _;
  }

  modifier gateThree() {
    if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
      _;
    }
  }

  function getAllowance(uint _password) public {                // 🚩
    if (trick.checkPassword(_password)) {
        allowEntrance = true;
    }
  }

  function createTrick() public {                                 
    trick = new SimpleTrick(payable(address(this)));            // Deploys trick contract
    trick.trickInit();
  }

  function enter() public gateOne gateTwo gateThree {
    entrant = tx.origin;
  }

  receive () external payable {}
}