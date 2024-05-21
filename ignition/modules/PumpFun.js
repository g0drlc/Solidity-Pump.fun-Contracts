const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xF1fA40e001AeE8aDE245Aa92f7ec948240Fc5AC7", "0x81A2a92ae760C555fd3D0A421A8B3261ff1b79F2", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});