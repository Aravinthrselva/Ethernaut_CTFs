//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 0xed8072FeE1F33995b31880091089e1fd4d94Eaa9
interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

