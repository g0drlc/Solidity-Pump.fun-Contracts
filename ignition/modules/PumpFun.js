const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xB8a0EA4964Bab55f3aFa46DE7e11cd0b83fE95c9", "0x2889f3A17242299414aEEf016a0587389a2e7c5a", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});