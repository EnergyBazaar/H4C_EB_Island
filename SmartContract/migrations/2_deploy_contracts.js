var Record = artifacts.require("./Record.sol");
var ExternalStorage = artifacts.require("./ExternalStorage.sol");



module.exports = function(deployer) {
  deployer.deploy(ExternalStorage);
  deployer.deploy(Record);
};
