const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x34D93e051846ec2B53bf78adE2fFeaFdEe1E0b64", "0x4200000000000000000000000000000000000006", 1]);

  return { router };
});