const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xd8B138cda3e5fE3E54735c9d5B1830b3e913Be3b", "0x4Da17A81618C99817B0Dd96898ED07bA54e3B18a", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});