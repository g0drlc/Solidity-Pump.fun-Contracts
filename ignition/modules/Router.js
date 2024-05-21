const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xbD59103a294Fb5958e34Cb93D4fCFe0D4bA531eA", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});