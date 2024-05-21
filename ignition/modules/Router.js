const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x30956E1EA7579172c6B7eE3639fc4b9998988a48", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});