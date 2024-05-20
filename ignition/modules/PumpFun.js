const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x30F403646134F53A5E31a4082b96b3F1e76e8745", "0x9Bd79d55bDfb5d816A2F2D0B5a93526C084c8654", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});