const { ethers } = require('hardhat')
const { expect, assert } = require('chai')

describe('SimpleStorage', () => {
  // what to do before everything
  let contract
  beforeEach(async () => {
    const contractFactory = await ethers.getContractFactory('SimpleStorage')

    contract = await contractFactory.deploy()
  })
  // test code to implement
  it('Should start with store value to be 0', async () => {
    const value = await contract.retrieve()
    const expectedValue = '0'
    assert.equal(value.toString(), expectedValue)
  })

  it('Able to update with correct value', async () => {
    const value = '7'
    await contract.store(value)
    const storedValue = await contract.retrieve()
    assert.equal(value, storedValue)
  })

  // we could add "only" to it function to run only that funtion when testing
  // eg: it.only("funtion description", async () => { function defenition})
})
