const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xfBA168E330a1E758e8F94a2788D23140db39150d", "0x4200000000000000000000000000000000000006"]);

  return { router };
});