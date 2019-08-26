pragma solidity ^0.4.8;
contract Paykaro {
    address public owner;
    uint public receivedWei;
    uint public returnedWei;
    struct Sender {
    uint received;
    uint returned;
    uint senderListPointer;
    } 
    mapping(address => Sender) public senderStructs;
    address[] public senderList;
    event LogReceivedFunds(address sender, uint amount);
    event LogReturnedFunds(address recipient, uint amount);
    function Receiver() {
    owner = msg.sender;
    }
    function getSenderCount() public constant returns(uint senderCount)
    {
        return senderList.length;

    }
    function isSender(address sender) public constant returns(bool isIndeed) {
        if(senderList.length==0) return false;
        return senderList[senderStructs[sender].senderListPointer]==sender;
    }
    function CashBack() payable public returns(bool success) {
        if(!isSender(msg.sender)) {
            senderStructs[msg.sender].senderListPointer = senderList.push(msg.sender)-1;
            senderStructs[msg.sender].returned = senderList.push(msg.sender)-1;

        }
        if(!isSender(msg.sender)) throw;
        uint netOwed = (msg.value)/2;
        // track cumulative receipts per sender
        senderStructs[msg.sender].returned += netOwed;
        senderStructs[msg.sender].received += netOwed;
        receivedWei += netOwed;
        returnedWei += netOwed;
        LogReceivedFunds(msg.sender, netOwed);
        LogReturnedFunds(msg.sender, netOwed);
        if(!msg.sender.send(netOwed)) throw; //
        return true;

    }

}
