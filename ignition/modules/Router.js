const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x7fFe96Dd625c85B5E2A60448aAb1998761E9C70f", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});