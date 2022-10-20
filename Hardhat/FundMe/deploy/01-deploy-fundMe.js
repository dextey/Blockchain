const { network } = require('hardhat')

const { networkConfig, developmentChains } = require('../helper-hardhat-config')

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  //   console.log(deployer)
  const chainId = network.config.chainId

  let priceFeedAddress

  if (developmentChains.includes(network.name)) {
    const mockV3Aggregator = await deployments.get('MockV3Aggregator')
    priceFeedAddress = mockV3Aggregator.address
  } else {
    priceFeedAddress = networkConfig[chainId]['priceFeedAddress']
  }
  log('Deploying Contract : FundMe')
  const fundMe = await deploy('FundMe', {
    from: deployer,
    args: [priceFeedAddress],
    log: true,
  })
  log('------------------------------------------')
}

module.exports.tags = ['all', 'fundme']
