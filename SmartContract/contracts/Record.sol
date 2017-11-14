pragma solidity ^0.4.8;

contract Record {
  address _id;
  bytes   encryptedId;
  int     power;

  event RecordConsumption(bytes _id, uint timeStamp);
  truevent RecordTransaction(bytes _from, bytes _to, uint timeStamp);

  modifier ownerOnly {
    if (msg.sender == _id) {
      _;
    } else {
      revert();
    }
  }

  function Record() {
    // constructor 
    _id = msg.sender;
    encryptedId = sha3(_id);
    RecordConsumption(encryptedId, now);
    
  }

  function setPower(uint _p) ownerOnly {
    power = _p;
  }

  // TestOnly
  function getPower() {

  }
}
