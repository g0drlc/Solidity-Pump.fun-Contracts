const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const router = m.contract("Router", ["0x1f76E39A46455ff93Fd74824755D4a69Fd42C729", "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"]);

  return { router };
});