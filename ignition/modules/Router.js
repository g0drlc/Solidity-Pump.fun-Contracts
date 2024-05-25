const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x1f76E39A46455ff93Fd74824755D4a69Fd42C729", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});