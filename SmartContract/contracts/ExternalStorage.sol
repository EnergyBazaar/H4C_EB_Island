pragma solidity ^0.4.8;

contract ExternalStorage {

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
  }

  // Simple set and get functions

  function setEnergy(address mAdr, int energyDelta) {
    // require... assert the address is in the network...
    profil[mAdr].energyAccumul += energyDelta;
  }

  function getEnergy(address mAdr) returns(int) {
    return profil[mAdr].energyAccumul;
  }

  function setBalance(address mAdr, uint balanceDelta) {
    // require... assert the address is in the network...
    profil[mAdr].balance += balanceDelta;
  }

  function getEnergy(address mAdr) returns(uint) {
    return profil[mAdr].balance;
  }

  function setIslandId(address mAdr, uint ilID) {
    // require... assert the address is in the network...
    profil[mAdr].islandID = ilID;
  }

  function getIslandId(address mAdr) returns(uint) {
    return profil[mAdr].islandID;
  }

  function setConnection(uint _id1, uint _id2) {
    //require(!getConnection(_id1, _id2));
    isConnected[_id1][_id2] = true;
  }

  function getConnection(uint _id1, uint _id2) returns(bool) {
    return isConnected[_id1][_id2];
  }
}
