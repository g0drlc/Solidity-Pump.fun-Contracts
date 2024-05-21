const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x3FEb6Ef048B3b42EfdD76f1990361F1a83C675e0", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});