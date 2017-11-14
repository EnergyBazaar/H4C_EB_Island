pragma solidity ^0.4.8;

import "./ExternalStorage.sol";

contract Record {
  /*address _id;
  int     power;

  address generator;
  address consumer;*/
  address   adminAdr;
  address   dataStorageAdr;
  address[] meterAdrs;

  event RecordConsumption(bytes _id, uint timeStamp);
  event RecordTransaction(bytes _from, bytes _to, uint _measuredAt);

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
  
  function Record() {
    // constructor
    adminAdr = msg.sender;
    dataStorageAdr = new ExternalStorage();
    
  }

  function addMeter(address mAdr, uint ilID) {
    require(!assertMeterIn(mAdr));
    meterAdrs.push(mAdr);
    profil[mAdr] = Portefeuille(0,0,ilID);

    // For now we do not delete the smart meter or disenable it..... (it mighted be a dead smart meter placed in the network)
  }


  function energyTransactRecord(address _to, uint _p) participantOnly(_to) participantOnly(msg.sender) returns (bool) {
    //require(assertMeterIn(msg.sender));
    address requester = msg.sender;
    ExternalStorage(dataStorageAdr).getConnection()
    

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


  // TestOnly
  function getPower() {

  }
}
