const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x27120eDaF483B1ca39435c2a54B06fD17C4e2735", "0xa4f90909992a327C8623661B3f29dE35A2802342", "0x6627f8ddc81057368F9717042E38E3DEcb68dAc3", 5, 5, 5]);

  return { pump_fun };
});