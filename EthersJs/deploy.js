import ethers from 'ethers'
import fs from 'fs-extra'
import dotenv from 'dotenv'

dotenv.config()

const deploy = async () => {
  const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL)
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

  const ABI = fs.readFileSync('./SimpleStorage_sol_SimpleStorage.abi', 'utf-8')
  const BINARY = fs.readFileSync(
    './SimpleStorage_sol_SimpleStorage.bin',
    'utf-8',
  )

  const contractFactory = new ethers.ContractFactory(ABI, BINARY, wallet)

  const contract = await contractFactory.deploy()

  return contract
  // Deployment transaction is a transaction response is what we get when we make a transaction
  // console.log(contract.deployTransaction)
  //  transaction receipt is what we get after transaction is finished
  // const transactionReceipt = await contract.deployTransaction.wait(1)
  // console.log(transactionReceipt)

  // Sending a Transaction in a low level way
  // const nonce = await wallet.getTransactionCount()

  // const tx = {
  //   nonce: nonce,
  //   gasPrice: 2000000000,
  //   gasLimit: 1000000,
  //   to: null,
  //   value: 0,
  //   data: '0x' + BINARY,
  //   chainId: 1337,
  // }

  // const sentTxResponse = await wallet.sendTransaction(tx)
  // await sentTxResponse.wait(1)
  // console.log(sentTxResponse)
}

const main = async (contract) => {
  const storeValue = await contract.retrieve()
  console.log(storeValue.toString())
  const transactionResponse = await contract.store('13')
  const transactionReceipt = await transactionResponse.wait(1)
  const updatedvalue = await contract.retrieve()
  console.log(updatedvalue.toString())
}

deploy()
  .then((res) => main(res))
  .catch((err) => console.log(err))
