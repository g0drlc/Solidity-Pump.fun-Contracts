const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x45166C7013f1df036cAd5Cb66225C5FA04775AC0", "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"]);

  return { router };
});