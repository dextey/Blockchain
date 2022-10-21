require('@nomicfoundation/hardhat-toolbox')
require('hardhat-deploy')
require('dotenv').config()
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // solidity: '0.8.17',
  solidity: {
    compilers: [{ version: '0.8.17' }, { version: '0.6.6' }],
  },
  gasReporter: {
    enabled: true,
    currency: 'INR',
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    // token: 'MATIC',
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    user: {
      default: 1,
    },
  },
}
