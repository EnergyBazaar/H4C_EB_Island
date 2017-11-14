var Record = artifacts.require("./Record.sol");
var ExternalStorage = artifacts.require("./ExternalStorage.sol");

contract('Test One Energy Island', function(accounts) {
  var address_admin = accounts [0];
  var address_m0 = accounts[1];
  var address_m1 = accounts[2];
  var address_m2 = accounts[3];
  var address_m3= accounts[4];
  var address_random= accounts[5];

  var configuration;
  var singleHouse0;
  var singleHouse1;
  var singleHouse2;
  var singlePV0;
  var singlePV1;
  var singlePV2;
  var singleBattery0;
  var grid_c;
  var singlePV0_adr;
  var singlePV1_adr;
  var singlePV2_adr;
  var singleHouse0_adr;
  var singleHouse1_adr;
  var singleBattery0_adr;
  var grid_adr;

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
    });    
  });
});