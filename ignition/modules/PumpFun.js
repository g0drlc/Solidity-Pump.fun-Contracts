const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xbD59103a294Fb5958e34Cb93D4fCFe0D4bA531eA", "0x3446e89a9Aa7CCA4d8CD3b08c253727c31fE5243", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});