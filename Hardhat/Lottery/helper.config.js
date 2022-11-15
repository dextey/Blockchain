const networkConfig = {
  5: {
    name: "goerli",
    vrfCoordinatorAddress: "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
    gaslane: "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15",
    subscriptionId: "0",
    gaslimit: "500000",
  },
  137: {
    name: "polygon",
    vrfCoordinatorAddress: "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed",
    gaslane: "0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f",
    subscriptionId: "0",
    gaslimit: "200000",
  },
  31337: {
    name: "hardhat",
    gaslane: "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15",
    gaslimit: "500000",
  },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
  networkConfig,
  developmentChains,
}
