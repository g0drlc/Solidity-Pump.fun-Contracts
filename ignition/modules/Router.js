const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x76CDEA651E0bE2a73E7B9B2c77Bc364e724c6a79", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});