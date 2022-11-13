const { assert } = require("chai")
const { deployments, getNamedAccounts, ethers } = require("hardhat")

describe("Contract - LuckyDraw", () => {
  let luckyDraw, deployer, player

  beforeEach(async () => {
    deployer = getNamedAccounts().deployer
    player = getNamedAccounts().player
    await deployments.fixture(["all"])
    luckyDraw = await ethers.getContract("LuckyDraw", deployer)
  })

  it("Constructor set Fee correcty", async () => {
    const fee = await luckyDraw.getEntranceFee()

    assert.equal(fee.toString(), ethers.utils.parseEther("0.1").toString())
  })

  it("Able to enter LuckyDraw contest", async () => {
    const accounts = await ethers.getSigners()
    const playerContract = await luckyDraw.connect(accounts[1])
    const txResponse = await playerContract.enterLuckyDraw({
      value: ethers.utils.parseEther("0.2"),
    })
    const txReceipt = await txResponse.wait(1)
    console.log(txReceipt)
    const players = await luckyDraw.getPlayers()
    console.log(players)
  })

  // it("Able to get players", async () => {
  //   const players = await lottery.getPlayer(0)
  //   console.log(players)
  // })
})
