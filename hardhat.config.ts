import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

export default {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 500,
      },
    },
  },
  mocha: {
    timeout: 3600000,
  },
  defaultNetwork: "testnet",
  networks: {
    testnet: {
      url: process.env.TESTNET_ENDPOINT,
      accounts: [process.env.TESTNET_OPERATOR_PRIVATE_KEY],
    },
  },
};
