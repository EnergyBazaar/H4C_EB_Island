var Record = artifacts.require("./Record.sol");
var ExternalStorage = artifacts.require("./ExternalStorage.sol");

contract('Test One Energy Island', function(accounts) {
  var address_admin = accounts[0];
  var address_m0 = accounts[1];
  var address_m1 = accounts[2];
  var address_m2 = accounts[3];
  var address_m3= accounts[4];
  var address_random= accounts[5];

  it("Set up 3 smart meters", function() {
    // Here to allocate account information + display them on the screen 
    return Record.deployed().then(function(instance){
      record = instance;
      record.addMeter(address_m0,101);
      record.addMeter(address_m1,101);
      record.addMeter(address_m2,102);
      return record.getAddress.call(0);
    }).then(function(result){
      console.log("The address of account 0 is =", result);
      return record.getAddress.call(1);
    }).then(function(result){
      console.log("The address of account 1 is =", result);
      return record.getEnergy.call(address_m0);
    }).then(function(result){
      console.log("The current energy balance of account 0 is =", result.toNumber());
      return record.getEnergy.call(address_m1);
    }).then(function(result){
      console.log("The current energy balance of account 1 is =", result.toNumber());

      record.energyTransactRecord(address_m1,3, {from: address_m0});
      //return record.energyTransactRecord.call(address_m1,3, {from: address_m0});
      //record.setEnergy(address_m1,3);
      //record.setEnergy(address_m0,-3);
    }).then(function(result){
      console.log("the transaction from m1 to m0 is?", result);
      return record.getEnergy.call(address_m0);
    }).then(function(result){
      console.log("The current energy balance of account 0 is =", result.toNumber());
      return record.getEnergy.call(address_m1);
    }).then(function(result){
      console.log("The current energy balance of account 1 is =", result.toNumber());
      return record.getBalance.call({from: address_m0});
    }).then(function(result){
      console.log("The current ether balance of account 0 is =", result.toNumber());
      return record.getBalance.call({from: address_m1});
    }).then(function(result){
      console.log("The current ether balance of account 1 is =", result.toNumber());
      //record.energyTransactRecord(address_m1,50, {from: address_m0});
      record.receiveEthers(address_m1, {value:150000000, from: address_m0});
      return record.getEnergy.call(address_m0);
    }).then(function(result){
      console.log("The current energy balance of account 0 is =", result.toNumber());
      return record.getEnergy.call(address_m1);
    }).then(function(result){
      console.log("The current energy balance of account 1 is =", result.toNumber());
      return record.getBalance.call({from: address_m0});
    }).then(function(result){
      console.log("The current ether balance of account 0 is =", result.toNumber());
      return record.getBalance.call({from: address_m1});
    }).then(function(result){
      console.log("The current ether balance of account 1 is =", result.toNumber());
    });    
  });

  
});