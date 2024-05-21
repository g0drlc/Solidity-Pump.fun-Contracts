const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x3FEb6Ef048B3b42EfdD76f1990361F1a83C675e0", "0x72c6f4B0E4F825c7d488883e99873C8Baeb15dc6", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});