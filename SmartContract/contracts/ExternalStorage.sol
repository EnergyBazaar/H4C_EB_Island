pragma solidity ^0.4.8;

contract ExternalStorage {

  struct Portefeuille {
    int     energyAccumul;
    int    balance;
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

  function addMeter(address mAdr, uint ilID) {
    profil[mAdr] = Portefeuille(0,0,ilID);
    setConnection(ilID,ilID);

    // For now we do not delete the smart meter or disenable it..... (it mighted be a dead smart meter placed in the network)
  }

  function setEnergy(address mAdr, int energyDelta) {
    // require... assert the address is in the network...
    profil[mAdr].energyAccumul += energyDelta;
  }

  function getEnergy(address mAdr) returns(int) {
    return profil[mAdr].energyAccumul;
  }

  function setBalance(address mAdr, int balanceDelta) {
    // require... assert the address is in the network...
    profil[mAdr].balance += balanceDelta;
  }

  function getBalance(address mAdr) returns(int) {
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

  function isNodesConnected(address mAdr1, address mAdr2) returns(bool) {
    uint temp1;
    uint temp2;
    temp1 = getIslandId(mAdr1);
    temp2 = getIslandId(mAdr2);
    return getConnection(temp1,temp2);
  }
}
