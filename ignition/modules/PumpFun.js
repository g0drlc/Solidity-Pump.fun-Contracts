const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xe7884Dd72Cc38746e211097c38a8875966f08953", "0x2d3689c8bCB5D98b740d22fb2C4FB62dC576f0Bd", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});