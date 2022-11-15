const { ethers, network } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper.config")

module.exports = async ({ deployments, getNamedAccounts }) => {
  const { deploy } = deployments
  const { deployer } = await getNamedAccounts()

  let vrfCoordinatorAddress, subscriptionId

  if (developmentChains.includes(network.name)) {
    const vrfCoordinator = await ethers.getContract("VRFCoordinatorV2Mock")
    vrfCoordinatorAddress = vrfCoordinator.address

    const txResponse = await vrfCoordinator.createSubscription()
    const txReceipt = await txResponse.wait(1)
    subscriptionId = txReceipt.events[0].args.subId
  } else {
    vrfCoordinatorAddress = networkConfig[network.config.chainId]["vrfCoordinatorAddress"]
    subscriptionId = networkConfig[network.config.chainId]["subscriptionId"]
  }

  /*
  address vrfCoordinatorV2,
  uint256 _entranceFee,
  bytes32 _gaslane,
  uint64 _subscriptionId,
  uint32 _gaslimit,
  uint256 _interval
  */
  const entranceFee = ethers.utils.parseEther("0.1")
  const gaslane = networkConfig[network.config.chainId]["gaslane"]
  const gaslimit = networkConfig[network.config.chainId]["gaslimit"]

  const interval = "30"

  const args = [vrfCoordinatorAddress, entranceFee, gaslane, subscriptionId, gaslimit, interval]

  console.log("Deploying -- LuckyDraw Contract")

  const LuckyDraw = await deploy("LuckyDraw", {
    from: deployer,
    args: args,
    log: true,
  })
  console.log("=====================================")
}

module.exports.tags = ["all", "LuckyDraw"]
