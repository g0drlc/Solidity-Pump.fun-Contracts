const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x4Fd9856C0Efc0C815E5E8C491cd2046520DD9F27", "0xEe9bAb8320a99540C169D968A2BC7D760979E60B", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});