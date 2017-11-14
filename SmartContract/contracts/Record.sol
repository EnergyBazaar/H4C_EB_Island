pragma solidity ^0.4.8;

import "./ExternalStorage.sol";

contract Record {
  address   adminAdr;
  address   dataStorageAdr;
  address[] meterAdrs;

  event RecordETransaction(bytes32 _from, bytes32 _to, uint _measuredAt);
  event RecordFTransaction(bytes32 _from, bytes32 _to, uint _sentAt);

  modifier adminOnly {
    if (msg.sender == adminAdr) {
      _;
    } else {
      revert();
    }
  }

  modifier producerOnly (int _energy){
    if (_energy > 0) {
      _;
    } else {
      revert();
    }
  }

  modifier participantOnly (address adr) {    // The address in in our network (in one of our energy islands)
    if (assertMeterIn(adr)) {
      _;
    } else {
      revert();
    }
  }

  // ==========SetUp=============
  
  function Record() {
    // constructor
    adminAdr = msg.sender;
    dataStorageAdr = new ExternalStorage();
    
  }
  
  function addMeter(address mAdr, uint ilID) public {
    require(!assertMeterIn(mAdr));
    meterAdrs.push(mAdr);
    ExternalStorage(dataStorageAdr).addMeter(mAdr, ilID);
    // For now we do not delete the smart meter or disenable it..... (it mighted be a dead smart meter placed in the network)
  }


  function setIslandId(address adr, uint _id) public {
    ExternalStorage(dataStorageAdr).setIslandId(adr, _id);
  }

  function setConnection(uint _id1, uint _id2) adminOnly public {
    ExternalStorage(dataStorageAdr).setConnection(_id1, _id2);
  }

// ==== Regular use ====

  function receiveEthers(address to) payable public {
    uint fValue;
    bytes32 _from;
    bytes32 _to;
    fValue = msg.value-1000;
    _from = keccak256("_from:",msg.sender);
    _to = keccak256("_to:",address(this));
    RecordFTransaction(_from, _to, now);
    sendEthers(to,fValue);    //each transaction will give 1000 wei as service fee
  }

  function sendEthers(address to, uint p) private {
    bytes32 _from;
    bytes32 _to;
    to.transfer(p);
    _from = keccak256("_from:",address(this));
    _to = keccak256("_to:",to);
    RecordFTransaction(_from, _to, now);
  }


  function energyTransactRecord(address _to, uint _p) participantOnly(_to) participantOnly(msg.sender) public returns (bool) {
    //require(assertMeterIn(msg.sender));
    address requester = msg.sender;
    if (ExternalStorage(dataStorageAdr).isNodesConnected(msg.sender, requester)) {
      ExternalStorage(dataStorageAdr).setEnergy(requester, -int(_p));
      ExternalStorage(dataStorageAdr).setEnergy(_to,int(_p));
      return true;
    } else {
      return false;
    }
  }

  /*function balanceTransactRecord(address _to, uint _p) participantOnly(_to) participantOnly(msg.sender) payable returns (bool) {
    //require(assertMeterIn(msg.sender));
    address requester = msg.sender;
    if (ExternalStorage(dataStorageAdr).isNodesConnected(msg.sender, requester)) {
      // Solution 1: recording financial settlement via integers
      ExternalStorage(dataStorageAdr).setBalance(requester, -_p);
      ExternalStorage(dataStorageAdr).setBalance(_to, _p);
      // Solution 2: recording the financial settlement via ethers
      _to.send(_p*3000000000000000);    // change to wei
      return true;
    } else {
      return false;
    }
  }*/

  // Assert information
  function assertMeterIn(address adr) private returns(bool) {
    for (var i = 0; i < meterAdrs.length; i++) {
      if (meterAdrs[i] == adr) {
        return true;
      }
    }
    return false;
  }

  // test functions

  function  getBalance() returns (uint) {
    address adr;
    adr = msg.sender;
    return adr.balance;
  }

  function getEnergy(address adr) returns(int) {
    return ExternalStorage(dataStorageAdr).getEnergy(adr);
  }

  function getMeter(address mAdr) returns(uint) {
    return ExternalStorage(dataStorageAdr).getMeter(mAdr);
  }

  /* 
  function getAddress(uint _id) returns(address) {
    return meterAdrs[_id];
  }

  function getdSadr() returns(address) {
    return dataStorageAdr;
  }

  function setEnergy(address adr, int vol) returns(int) {
   ExternalStorage(dataStorageAdr).setEnergy(adr,vol);
  }*/
}
