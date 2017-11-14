pragma solidity ^0.4.8;

contract ExternalStorage {

  address   adminAdr;

  struct Portefeuille {
    int     energyAccumul;
    uint    balance;
    uint    islandID;
  }
  
  mapping(address=>Portefeuille) profil;
  mapping(uint=>mapping(uint=>bool)) isConnected;

  //event MeterLog(int energyDelta, uint changeAt);
  // events should be placed in the main contract...

  function ExternalStorage() {
    // constructor
    adminAdr = msg.sender;
  }

  modifier adminOnly {
    if (msg.sender == adminAdr) {
      _;
    } else {
      revert();
    }
  }

  // Simple set and get functions

  function addMeter(address mAdr, uint ilID) adminOnly {
    profil[mAdr] = Portefeuille(0,100,ilID);    //By default we allocatoin 100 points into the account
    setConnection(ilID,ilID);

    // For now we do not delete the smart meter or disenable it..... (it mighted be a dead smart meter placed in the network)
  }

  function getMeter(address mAdr) adminOnly returns(uint) {
    return profil[mAdr].islandID;
  }

  function setEnergy(address mAdr, int energyDelta) adminOnly {
    // require... assert the address is in the network...
    profil[mAdr].energyAccumul += energyDelta;

  }

  function getEnergy(address mAdr) adminOnly returns(int) {
    return profil[mAdr].energyAccumul;
  }

  function setBalance(address mAdr, uint balanceDelta) adminOnly {
    // require... assert the address is in the network...
    profil[mAdr].balance += balanceDelta;
  }

  function getBalance(address mAdr) adminOnly returns(uint) {
    return profil[mAdr].balance;
  }

  function setIslandId(address mAdr, uint ilID) adminOnly {
    // require... assert the address is in the network...
    profil[mAdr].islandID = ilID;
  }

  function getIslandId(address mAdr) adminOnly returns(uint) {
    return profil[mAdr].islandID;
  }

  function setConnection(uint _id1, uint _id2) adminOnly {
    //require(!getConnection(_id1, _id2));
    isConnected[_id1][_id2] = true;
  }

  function getConnection(uint _id1, uint _id2) adminOnly returns(bool) {
    return isConnected[_id1][_id2];
  }

  function isNodesConnected(address mAdr1, address mAdr2) adminOnly returns(bool) {
    uint temp1;
    uint temp2;
    temp1 = getIslandId(mAdr1);
    temp2 = getIslandId(mAdr2);
    return getConnection(temp1,temp2);
  }
}
