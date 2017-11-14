pragma solidity ^0.4.8;

import "./ExternalStorage.sol";

contract Record {
  address   adminAdr;
  address   dataStorageAdr;
  address[] meterAdrs;

  event RecordTransaction(bytes _from, bytes _to, uint _measuredAt);

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

  function getdSadr() returns(address) {
    return dataStorageAdr;
  }
  function addMeter(address mAdr, uint ilID) {
    require(!assertMeterIn(mAdr));
    meterAdrs.push(mAdr);
    ExternalStorage(dataStorageAdr).addMeter(mAdr, ilID);
    // For now we do not delete the smart meter or disenable it..... (it mighted be a dead smart meter placed in the network)
  }

  function getMeter(address mAdr) returns(uint) {
    return ExternalStorage(dataStorageAdr).getMeter(mAdr);
  }

  function setIslandId(address adr, uint _id) {
    ExternalStorage(dataStorageAdr).setIslandId(adr, _id);
  }

  function setConnection(uint _id1, uint _id2) adminOnly {
    ExternalStorage(dataStorageAdr).setConnection(_id1, _id2);
  }



  function energyTransactRecord(address _to, uint _p) participantOnly(_to) participantOnly(msg.sender) returns (bool) {
    //require(assertMeterIn(msg.sender));
    address requester = msg.sender;
    //if (ExternalStorage(dataStorageAdr).isNodesConnected(msg.sender, requester)) {
      ExternalStorage(dataStorageAdr).setEnergy(requester, -int(_p));
      ExternalStorage(dataStorageAdr).setEnergy(_to,int(_p));
      return true;
    //} else {
    //  return false;
    //}
  }

  function balanceTransactRecord(address _to, int _p) participantOnly(_to) participantOnly(msg.sender) returns (bool) {
    //require(assertMeterIn(msg.sender));
    address requester = msg.sender;
    if (ExternalStorage(dataStorageAdr).isNodesConnected(msg.sender, requester)) {
      ExternalStorage(dataStorageAdr).setBalance(requester, _p);
      ExternalStorage(dataStorageAdr).setBalance(_to, _p);
      return true;
    } else {
      return false;
    }
  }

  // Assert information
  function assertMeterIn(address adr) returns(bool) {
    for (var i = 0; i < meterAdrs.length; i++) {
      if (meterAdrs[i] == adr) {
        return true;
      }
    }
    return false;
  }

  // test functions

  function getAddress(uint _id) returns(address) {
    return meterAdrs[_id];
  }

  function getEnergy(address adr) returns(int) {
    return ExternalStorage(dataStorageAdr).getEnergy(adr);
  }

  function setEnergy(address adr, int vol) returns(int) {
   ExternalStorage(dataStorageAdr).setEnergy(adr,vol);
  }
}
