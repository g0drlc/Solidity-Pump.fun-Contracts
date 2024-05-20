const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const factory = m.contract("Factory", ["0x6627f8ddc81057368F9717042E38E3DEcb68dAc3"]);

  return { factory };
});