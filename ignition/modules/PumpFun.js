const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x7fFe96Dd625c85B5E2A60448aAb1998761E9C70f", "0x90731fC06c08B78Fd4C39F1821923F6Cda6Ee036", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});