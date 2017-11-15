var Record = artifacts.require("./Record.sol");
var ExternalStorage = artifacts.require("./ExternalStorage.sol");

/*var provider = new Web3.providers.HttpProvider("http://localhost:8545");
var contract = require("truffle-contract");

var MyContract = contract({
  abi: ...,
  unlinked_binary: ...,
  address: ..., // optional
  // many more
})
MyContract.setProvider(provider);*/

contract('Test One Energy Island', function(accounts) {
  var address_admin = accounts[0];
  var address_m0 = accounts[1];
  var address_m1 = accounts[2];
  var address_m2 = accounts[3];
  var address_m3= accounts[4];
  var address_random= accounts[5];
  var address_st;
  var ST;

  it("Set up 3 smart meters", function() {
    // Here to allocate account information + display them on the screen 
    return Record.deployed().then(function(instance){
      record = instance;
      record.addMeter(address_m0,101);
      record.addMeter(address_m1,101);
      record.addMeter(address_m2,102);
      return record.getdSadr.call();
    }).then(function(result){
      address_st = result;
      ST = ExternalStorage.at(address_st);
      ST.setIslandId(address_m0,100);
      console.log("The address of account 0 is =", result);
      return ST.getMeter.call(address_m0);
    }).then(function(result){
      console.log("ID of m0 is (St method)", result);
      record.setIslandId(address_m0,101);
      return record.getMeter.call(address_m0);
    }).then(function(result){
      console.log("ID of m0 is (St method)", result);
    });    
  });

  it("Test out the connectivity check & sending the balance", function() {
    // Here to allocate account information + display them on the screen 
    return ST.isNodesConnected.call(address_m1,address_m0).then(function(result){
      console.log("The connectivity between m1 and m0 is", result);
      return ST.isNodesConnected.call(address_m1,address_m2);
    }).then(function(result){
      console.log("The connectivity between m1 and m2 is", result);
      return ST.getBalance.call(address_m0);
    }).then(function(result){
      console.log("The balance in account 0 is =", result.toNumber());
      return ST.getBalance.call(address_m1);
    }).then(function(result){
      console.log("The balance in account 1 is =", result.toNumber());
      record.balanceTransactRecord(address_m1,50, {from: address_m0});
      return ST.getBalance.call(address_m0);
    }).then(function(result){
      console.log("The balance in account 0 is =", result.toNumber());
      return ST.getBalance.call(address_m1);
    }).then(function(result){
      console.log("The balance in account 1 is =", result.toNumber());
    });    
  });
});