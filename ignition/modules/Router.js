const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xCd79c0370a0224f1a6ceF7F668E51586CaFb80DA", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});