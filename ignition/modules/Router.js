const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xF1fA40e001AeE8aDE245Aa92f7ec948240Fc5AC7", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});