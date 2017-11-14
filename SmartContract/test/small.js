var Record = artifacts.require("./Record.sol");
var ExternalStorage = artifacts.require("./ExternalStorage.sol");

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
});