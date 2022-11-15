const { network } = require("hardhat")
const { developmentChains } = require("../helper.config")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts()
  const { deploy, log } = deployments

  const BASE_FEE = ethers.utils.parseEther("0.25")
  const GAS_PRICE_LINK = 1e9

  if (developmentChains.includes(network.name)) {
    console.log("Localhost Detected -- Deploying mocks")
    console.log("===================================================")
    await deploy("VRFCoordinatorV2Mock", {
      from: deployer,
      log: true,
      args: [BASE_FEE, GAS_PRICE_LINK],
    })
    console.log("===================================================")
  }
}

module.exports.tags = ["all", "mocks"]
