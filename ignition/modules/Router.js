const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xe7884Dd72Cc38746e211097c38a8875966f08953", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});