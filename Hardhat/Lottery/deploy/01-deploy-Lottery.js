const { ethers } = require("hardhat")

module.exports = async ({ deployments, getNamedAccounts }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()

  const LuckyDraw = await deploy("LuckyDraw", {
    from: deployer,
    args: [ethers.utils.parseEther("0.1")],
    log: true,
  })
}

module.exports.tags = ["all", "LuckyDraw"]
