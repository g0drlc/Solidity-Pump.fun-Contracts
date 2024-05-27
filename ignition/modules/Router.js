const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x6eDB8657DBf6b5Eb645E02385f54B8CD362F09B9", "0x4200000000000000000000000000000000000006"]);

  return { router };
});