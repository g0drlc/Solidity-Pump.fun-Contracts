const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xfBA168E330a1E758e8F94a2788D23140db39150d", "0x19C194d8c39c9e5015021a11939C9c7E62fC06E7", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5]);

  return { pump_fun };
});