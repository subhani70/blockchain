module.exports = {
  networks: {
    // Ganache/Local development network
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 8000000,
      gasPrice: 20000000000
    },
    
    // Your Private PoA Blockchain
    poa: {
      host: "172.16.10.117",
      port: 8545,
      network_id: 1234567,
      from: "0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5", // Your account address
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