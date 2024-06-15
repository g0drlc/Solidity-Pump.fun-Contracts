const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0xCd79c0370a0224f1a6ceF7F668E51586CaFb80DA", "0x138475dDC8d6180efFda1833188E8A273E477150", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});