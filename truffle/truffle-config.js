module.exports = {
  networks: {
    // Local development
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 1234567,
      from: "0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5",
      gas: 8000000,
      gasPrice: 2000000000,
      websockets: false
    },

    // Remote AWS deployment
    voltus: {
      host: "13.232.1.197",
      port: 8545,
      network_id: 1234567,
      from: "0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5",
      gas: 8000000,
      gasPrice: 2000000000,
      websockets: false
    }
  },

  compilers: {
    solc: {
      version: "0.8.19",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};