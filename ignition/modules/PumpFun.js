const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x1f76E39A46455ff93Fd74824755D4a69Fd42C729", "0xC4AF297Dd1e63Efb6aE5C751eeAD554aB8A5DDF0", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});