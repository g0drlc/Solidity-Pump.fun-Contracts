const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x9B0fa0d117668fC8c6D95E29fcA4E0dE2E64A077", "0x6aCA3B1527E091df167B8821E2392BF1c39a8013", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});