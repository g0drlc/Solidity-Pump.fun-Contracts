const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x76CDEA651E0bE2a73E7B9B2c77Bc364e724c6a79", "0x3bcAF2dEd46a51B1e7cC6a2d49AD4a1413052369", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});