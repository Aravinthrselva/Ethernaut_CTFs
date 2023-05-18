pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/03.CoinFlipAttack.sol";

contract CoinFlipAttackTest is Test { 

    address coinContract = 0x3F8eBf4Caa486a69646190D1818c6349140565C8;
    address deployer ;
    CoinAttack coinAttack;

    function setUp() public {

        coinAttack = new CoinAttack(coinContract);
        console.log("Coin Attack contract address : ", address(coinAttack));
        console.log("deployer contract address : ", address(this));
            

    }

    function attack() public {
        for(uint i=0; i<10; i++) {
        coinAttack.flipAttack();
        }
    }

}