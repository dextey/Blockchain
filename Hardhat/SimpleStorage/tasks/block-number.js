// Import task from hardhat congif for the creation of new task
const { task } = require('hardhat/config')

task('block-number', 'Prints the current block number').setAction(
  //taskArgs is arguments passed when calling task | here there will be no arguments
  //hre is the hardhat envirionment which is similar to calling require(hardhat)
  async (taskArgs, hre) => {
    const blockNumber = await hre.ethers.provider.getBlockNumber()
    console.log(`Block number : ${blockNumber}`)
  },
)

module.exports = {}
