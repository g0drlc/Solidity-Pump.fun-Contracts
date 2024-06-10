const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const pump_fun = m.contract("PumpFun", ["0x34D93e051846ec2B53bf78adE2fFeaFdEe1E0b64", "0x2d39205abA87704acBF143d89D0152dc50e08462", "0x03640D168B2C5F35c9C7ef296f0F064a90E5FA62", 5]);

  return { pump_fun };
});