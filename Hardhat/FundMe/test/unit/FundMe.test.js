const { getNamedAccounts, deployments, ethers } = require('hardhat')
const { assert, expect } = require('chai')

describe('Contract - FundMe', () => {
  let fundMe
  let mockV3Aggregator
  let deployer
  const sendValue = ethers.utils.parseEther('1')
  beforeEach(async () => {
    deployer = (await getNamedAccounts()).deployer
    await deployments.fixture(['all'])
    fundMe = await ethers.getContract('FundMe', deployer)
    mockV3Aggregator = await ethers.getContract('MockV3Aggregator', deployer)
  })

  describe('Constructor', () => {
    it('Correct aggregator Address', async () => {
      const response = await fundMe.s_priceFeed()
      assert.equal(response, mockV3Aggregator.address)
    })
  })

  describe('Fund', () => {
    it("Emitting error if you don't send eth worth 50$", async () => {
      await expect(fundMe.fund()).to.be.revertedWith(
        'Send atleast 50$ worth ethereum',
      )
    })
    it('Able to fund eth ', async () => {
      await fundMe.fund({ value: sendValue })
      const response = await fundMe.s_addressFunded(deployer)
      assert.equal(response.toString(), sendValue)
    })
  })

  describe('WithDraw', () => {
    beforeEach(async () => {
      await fundMe.fund({ value: sendValue })
    })
    it('Able to withdraw fund from contract', async () => {
      //Arrange
      const contractBalance = await fundMe.provider.getBalance(fundMe.address)
      const deployerBalance = await fundMe.provider.getBalance(deployer)

      //Act
      const transationResponse = await fundMe.withDraw()
      const transactionReceipt = await transationResponse.wait(1)

      const { gasUsed, effectiveGasPrice } = transactionReceipt

      const contractAfterBal = await fundMe.provider.getBalance(fundMe.address)
      const deployerBalanceAfter = await fundMe.provider.getBalance(deployer)
      const gasPrice = gasUsed.mul(effectiveGasPrice)
      //Assert
      assert.equal(contractAfterBal.toString(), 0)
      assert.equal(
        deployerBalance.add(contractBalance).toString(),
        deployerBalanceAfter.add(gasPrice).toString(),
      )
    })

    it('Able to fund with Multiple Accounts', async () => {
      const accounts = await ethers.getSigners()

      for (let i = 1; i < 6; ++i) {
        const contract = await fundMe.connect(accounts[i])
        await contract.fund({ value: sendValue })
      }

      const contractBalance = await fundMe.provider.getBalance(fundMe.address)
      const deployerBalance = await fundMe.provider.getBalance(deployer)

      //Act
      const transationResponse = await fundMe.withDraw()
      const transactionReceipt = await transationResponse.wait(1)

      const { gasUsed, effectiveGasPrice } = transactionReceipt

      const contractAfterBal = await fundMe.provider.getBalance(fundMe.address)
      const deployerBalanceAfter = await fundMe.provider.getBalance(deployer)
      const gasPrice = gasUsed.mul(effectiveGasPrice)
      //Assert
      assert.equal(contractAfterBal.toString(), 0)
      assert.equal(
        deployerBalance.add(contractBalance).toString(),
        deployerBalanceAfter.add(gasPrice).toString(),
      )
    })

    it('Only owner can Withdraw funds', async () => {
      const accounts = await ethers.getSigners()
      const attacker = accounts[2]

      const attackerContract = await fundMe.connect(attacker)

      await expect(attackerContract.withDraw()).to.be.revertedWithCustomError(
        fundMe,
        'FundMe__NotOwner',
      )
    })
  })
})
