// SPDX-License-Identifier: MIT
// pragma solidity >=0.7.0;
pragma solidity >=0.5.5 < 0.7.5;

import "tabookey-gasless/contracts/GsnUtils.sol";
import "tabookey-gasless/contracts/IRelayHub.sol";
import "tabookey-gasless/contracts/RelayRecipient.sol";

contract Counterfeit{
    function buyProduct(bytes32 _secretId) external returns(bool) {}
}

contract Buy is RelayRecipient {
    
    event productPurchased(address buyerAddress);

    address private owner;
    Counterfeit C;

    constructor (IRelayHub _rhub) public{
        owner = getSender();
        setRelayHub(_rhub);
    }

    modifier onlyOwner(){
        require(getSender() == owner,"You can not set maincontract address");
        _;
    }

    function setMainContract( address _address) onlyOwner external {
        C = Counterfeit(_address);
    }

    function changeOwner(address _newOwner) onlyOwner external{
        owner = _newOwner;
    }

    function buyProduct(uint256 _secretId) external {
        bytes32 hash = keccak256(abi.encodePacked(_secretId));
        C.buyProduct(hash);
        emit productPurchased(getSender());

    }

    function acceptRelayedCall(address relay, address from, bytes calldata encodedFunction, uint256 transactionFee, uint256 gasPrice, uint256 gasLimit, uint256 nonce, bytes calldata approvalData, uint256 maxPossibleCharge) external view returns (uint256, bytes memory) {
        // all methods of this contract can be called with gas relay fuctionality....
        return (0, "");
    }

    function preRelayedCall(bytes calldata context) external returns (bytes32){
        return bytes32(uint(123456));
    }

    function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) /*relayHubOnly*/ external {
        return;
    }

}
