const { ethers } = require('hardhat')

const main = async () => {
  const contractfactory = await ethers.getContractFactory('SimpleStorage')
  const contract = await contractfactory.deploy()
  console.log(contract.address)

  return contract
}

main()
  .then(async (contract) => {
    const value = await contract.retrieve()
    console.log(value.toString())
    await contract.store('7')
    const updatedValue = await contract.retrieve()
    console.log(`update value : ${updatedValue}`)
  })
  .catch((err) => {
    console.log(err)
    process.exit(1)
  })
