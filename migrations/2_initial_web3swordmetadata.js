const SwordMetadata = artifacts.require("SwordMetadata");

module.exports = function (deployer) {
  deployer.deploy(SwordMetadata);
};