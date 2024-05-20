const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x27120eDaF483B1ca39435c2a54B06fD17C4e2735", "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"]);

  return { router };
});