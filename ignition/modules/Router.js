const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xB8a0EA4964Bab55f3aFa46DE7e11cd0b83fE95c9", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});