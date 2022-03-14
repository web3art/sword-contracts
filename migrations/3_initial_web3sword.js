/* eslint-disable no-undef */
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const SwordMetadata = artifacts.require("SwordMetadata");
const Web3Sword = artifacts.require("Web3Sword");

module.exports = async function (deployer, network) {
  const SwordMetadataI = await SwordMetadata.deployed();
  const Web3SwordI = await deployProxy(Web3Sword, [SwordMetadataI.address], { deployer, kind: 'uups' });
  console.log('Deployed Web3Sword', Web3SwordI.address);
};