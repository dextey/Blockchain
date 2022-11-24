const SHA256 = require("crypto-js/sha256");
class Block {
  constructor(data) {
    this.index = 0;
    this.timestamp = new Date().getTime();
    this.data = data;
    this.previousHash = "0x00";
    this.hash = this.calculateHash();
    this.nounce = 0;
  }

  calculateHash() {
    return SHA256(
      this.nounce +
        this.timestamp +
        JSON.stringify(this.data) +
        this.previousHash +
        this.nounce
    ).toString();
  }

  mineBlock(difficulty) {
    while (
      this.hash.substring(0, difficulty) !== Array(difficulty + 1).join("0")
    ) {
      this.nounce++;
      this.hash = this.calculateHash();
    }
    console.log("Blocked Mine " + this.hash);
  }
}

class BlockChain {
  constructor() {
    this.chain = [this.createGenesisBlock()];
    this.difficulty = 4;
  }

  createGenesisBlock() {
    return new Block({ value: 3 });
  }

  addBlock(newBlock) {
    newBlock.index = this.chain[this.chain.length - 1].index + 1;
    newBlock.previousHash = this.chain[this.chain.length - 1].hash;
    newBlock.mineBlock(this.difficulty);
    this.chain.push(newBlock);
  }

  verifyBlocks() {
    for (let index = 1; index < this.chain.length; index++) {
      const currentBlock = this.chain[index];
      const previousBlock = this.chain[index - 1];
      if (currentBlock.hash !== currentBlock.calculateHash()) return false;
      if (currentBlock.previousHash !== previousBlock.hash) return false;
    }
    return true;
  }
}

const blockchain = new BlockChain();

blockchain.addBlock(new Block({ value: 78 }));
blockchain.addBlock(new Block({ value: 58 }));
blockchain.addBlock(new Block({ value: 108 }));
const verified = blockchain.verifyBlocks();
console.log(JSON.stringify(blockchain.chain, null, 4));
// console.log(verified);

// blockchain.chain[1].data.value = 8;
// blockchain.chain[1].hash = blockchain.chain[1].calculateHash();
// console.log(JSON.stringify(blockchain, null, 4));
// console.log(blockchain.verifyBlocks());
