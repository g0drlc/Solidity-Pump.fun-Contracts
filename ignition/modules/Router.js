const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x4Fd9856C0Efc0C815E5E8C491cd2046520DD9F27", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});