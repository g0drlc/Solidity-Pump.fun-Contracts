const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x9Bd79d55bDfb5d816A2F2D0B5a93526C084c8654", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});