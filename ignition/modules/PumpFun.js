const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x6eDB8657DBf6b5Eb645E02385f54B8CD362F09B9", "0x502aB81dC064AA3c946c19293dDaCFC7f415f967", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5]);

  return { pump_fun };
});