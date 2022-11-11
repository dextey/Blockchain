const hre = require("hardhat");

async function main() {
  const SimpleStoreage = await hre.ethers.getContractFactory("SimpleStorage");
  const simpleStorage = await SimpleStoreage.deploy();

  await simpleStorage.deployed();

  const transactionResponse = await simpleStorage.store(1);
  const transactionReceipt = await transactionResponse.wait();

  console.log(transactionReceipt.events[0].args.oldNumber.toString());
  console.log(transactionReceipt.events[0].args.newNumber.toString());
  console.log(transactionReceipt.events[0].args.addedNumber.toString());
  console.log(transactionReceipt.events[0].args.sender);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
