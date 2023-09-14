//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// DoubleEntryPoint(main contract)     - 0x2b45aA590AA9A1c22F930aF0FBF17090cEa40351
// crypto vault                        - 0x33062ae2E184558e0D5d4B7e31784B1590585222
// delegateFrom(legacyERC20 contract)  - 0x601ae386BBa61609fbeAF546204546d7e1D2b252
// Forta contract                      - 0xe6a0C34A4C6D5b013677C733D4bbEA1C4EfD24A9
// player/ user                        - 0x01e07A5371035BeC2A86e1Ff9eaAC6b002edB102

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}


/*
We are calling delegateTransfer but that is not the calldata our bot will receive. 
You see, this function has a modifier fortaNotify. 
The modifier is not a message call, 
but simply replaces code with respect to the execution line (_;). 
During notify, the msg.data is passed as a parameter, 
so this has the structure of the calldata shown in the table above.

After notify, our detection bot's handleTransaction is called with the same msg.data passed to notify. 
So, during handleTransaction, the calldata will have the actual calldata to call that function, 
and the delegateCall calldata as an argument.


position	bytes	type	                                    value
0x00	     4	    bytes4	                Function selector of handleTransaction which is 0x220ab6aa
0x04	     32	    address (padded)	    user parameter
0x24	     32	    uint256	                offset of msgData parameter, 0x40 in this case
0x44	     32	    uint256	                length of msgData parameter, 0x64 in this case
0x64 *	     4	    bytes4	                Function selector of delegateTransfer which is 0x9cd1a121
0x68 *	     32	    address (padded)	    to parameter
0x88 *	     32 	uint256	                value parameter
0xA8 *	     32	    address (padded)	    origSender parameter the one we want
0xC8	     28	    padding	                zero-padding as per the 32-byte arguments rule of encoding bytes

The * marks the original calldata when delegateTransfer is called

*/

contract FortaBot is IDetectionBot {

address cryptoVaultAddr;

constructor(address _cryptoVaultAddr) {
    cryptoVaultAddr = _cryptoVaultAddr;
}

function handleTransaction(address user, bytes calldata msgData) public {

    address origSender;

    assembly {
        origSender := calldataload(0xa8)
    }

    if (origSender == cryptoVaultAddr)
    IForta(msg.sender).raiseAlert(user);
}

}


