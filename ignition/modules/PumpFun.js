const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x45166C7013f1df036cAd5Cb66225C5FA04775AC0", "0x90d921bA75b77adC9FDa811bd77147B4Ba12b2A5", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5]);

  return { pump_fun };
});