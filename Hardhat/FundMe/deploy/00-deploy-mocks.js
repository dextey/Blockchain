const { network } = require('hardhat')
const { developmentChains } = require('../helper-hardhat-config')

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()

  if (developmentChains.includes(network.name)) {
    log('Deploying in Local Network')
    log('---------------------------------')

    await deploy('MockV3Aggregator', {
      contract: 'MockV3Aggregator',
      from: deployer,
      log: 'true',
      args: [8, 200000000000],
    })

    log('---------------------------------')
  }
}

module.exports.tags = ['all', 'mocks']
