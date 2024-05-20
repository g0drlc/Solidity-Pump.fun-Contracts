const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x30F403646134F53A5E31a4082b96b3F1e76e8745", "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"]);

  return { router };
});