const { assert, expect } = require("chai")
const { deployments, getNamedAccounts, ethers } = require("hardhat")

describe("Contract - LuckyDraw", () => {
  let luckyDraw, vrfCoordinatorV2Mock, deployer, player

  beforeEach(async () => {
    deployer = getNamedAccounts().deployer
    player = getNamedAccounts().player
    await deployments.fixture(["all"])
    luckyDraw = await ethers.getContract("LuckyDraw", deployer)
    vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock", deployer)
  })
  describe("Constructor", () => {
    it("Lucky Draw State is Open", async () => {
      const luckyDrawState = await luckyDraw.getLuckyDrawState()
      assert.equal(luckyDrawState.toString(), 0)
    })
    it("Constructor set Fee correcty", async () => {
      const fee = await luckyDraw.getEntranceFee()

      assert.equal(fee.toString(), ethers.utils.parseEther("0.1").toString())
    })
  })
  describe("Enter LuckyDraw Contest", () => {
    it("Rejecting low eth entry", async () => {
      await expect(luckyDraw.enterLuckyDraw()).to.be.revertedWithCustomError(
        luckyDraw,
        "LuckyDraw_NotEnoughETHentered"
      )
    })
    it("Able to enter LuckyDraw contest", async () => {
      const accounts = await ethers.getSigners()
      const playerContract = await luckyDraw.connect(accounts[1])
      const txResponse = await playerContract.enterLuckyDraw({
        value: ethers.utils.parseEther("0.2"),
      })
      const txReceipt = await txResponse.wait(1)
      // console.log(txReceipt.events)
      const players = await luckyDraw.getPlayers()
      assert.equal(players[0], accounts[1].address)
    })
    it("Emits event LuckyDraw entry on player enter", async () => {
      await expect(luckyDraw.enterLuckyDraw({ value: ethers.utils.parseEther("0.2") })).to.emit(
        luckyDraw,
        "LuckyDrawEntry"
      )
    })
  })
  // it("Able to get players", async () => {
  //   const players = await lottery.getPlayer(0)
  //   console.log(players)
  // })
})
