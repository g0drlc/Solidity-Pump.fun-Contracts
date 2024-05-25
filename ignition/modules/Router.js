const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x45166C7013f1df036cAd5Cb66225C5FA04775AC0", "0x1BDD24840e119DC2602dCC587Dd182812427A5Cc"]);

  return { router };
});