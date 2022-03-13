/* eslint-disable no-undef */
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Web3Sword = artifacts.require("Web3Sword");

module.exports = async function (deployer, network) {
  const Web3SwordI = await deployProxy(Web3Sword, [], { deployer, kind: 'uups' });
  console.log('Deployed Web3Sword', Web3SwordI.address);
};