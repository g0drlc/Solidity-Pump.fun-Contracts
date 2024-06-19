const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x9B0fa0d117668fC8c6D95E29fcA4E0dE2E64A077", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});