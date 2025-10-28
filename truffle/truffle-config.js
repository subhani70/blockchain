module.exports = {
  networks: {
    // Private PoA Blockchain - Node 1 (Primary)
    poa: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 1234567,
      from: "0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5", // Node 1 account
      gas: 8000000,
      gasPrice: 2000000000,
      websockets: false
    },
    
    // Private PoA Blockchain - Node 2 (Alternative)
    poa2: {
      host: "127.0.0.1",
      port: 8546,
      network_id: 1234567,
      from: "0x18073Ba5476b50148ff1f5187a32Afc8F39Eb7Ff", // Node 2 account
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