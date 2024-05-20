const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0xd8B138cda3e5fE3E54735c9d5B1830b3e913Be3b", "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"]);

  return { router };
});