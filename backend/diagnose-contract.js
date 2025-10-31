const { ethers } = require('ethers');

async function diagnoseContract() {
    console.log('🔍 Starting Contract Diagnostics\n');
    console.log('='.repeat(50));

    // Configuration
    const RPC_URL = 'http://13.232.1.197:8545';
    const CONTRACT_ADDRESS = '0xB82F6787fDD6745A441E6649C6A08087F85BA191';
    const TEST_ADDRESS = '0xeAF7B68582887e33fA262210808062396f9C7747';

    try {
        // Step 1: Check Provider Connection
        console.log('\n📡 Step 1: Checking Provider Connection');
        const provider = new ethers.providers.JsonRpcProvider(RPC_URL);

        const blockNumber = await provider.getBlockNumber();
        console.log('   ✅ Provider connected successfully');
        console.log('   📦 Current block:', blockNumber);

        // Step 2: Check Network
        console.log('\n🌐 Step 2: Checking Network');
        const network = await provider.getNetwork();
        console.log('   ✅ Network Name:', network.name);
        console.log('   🔗 Chain ID:', network.chainId);

        // Step 3: Check if Contract Exists
        console.log('\n📄 Step 3: Checking Contract Deployment');
        const code = await provider.getCode(CONTRACT_ADDRESS);
        console.log('   📝 Bytecode Length:', code.length, 'characters');

        if (code === '0x') {
            console.log('   ❌ CONTRACT NOT DEPLOYED!');
            console.log('   ⚠️  No contract found at this address on chain', network.chainId);
            console.log('\n💡 Possible Issues:');
            console.log('   1. Contract not deployed to this network');
            console.log('   2. Wrong contract address');
            console.log('   3. Contract deployment failed');
            return;
        } else {
            console.log('   ✅ Contract EXISTS at address');
            console.log('   📊 Bytecode:', code.substring(0, 66) + '...');
        }

        // Step 4: Try Different Method Signatures
        console.log('\n🔬 Step 4: Testing Different Method Signatures');

        // Test 1: changed(address) - returns uint256
        console.log('\n   Testing: changed(address) returns (uint256)');
        try {
            const abi1 = ['function changed(address) view returns (uint256)'];
            const contract1 = new ethers.Contract(CONTRACT_ADDRESS, abi1, provider);
            const result1 = await contract1.changed(TEST_ADDRESS);
            console.log('   ✅ SUCCESS! Result:', result1.toString());
        } catch (err) {
            console.log('   ❌ FAILED:', err.code || err.message.substring(0, 50));
        }

        // Test 2: changed(address) - returns bool
        console.log('\n   Testing: changed(address) returns (bool)');
        try {
            const abi2 = ['function changed(address) view returns (bool)'];
            const contract2 = new ethers.Contract(CONTRACT_ADDRESS, abi2, provider);
            const result2 = await contract2.changed(TEST_ADDRESS);
            console.log('   ✅ SUCCESS! Result:', result2);
        } catch (err) {
            console.log('   ❌ FAILED:', err.code || err.message.substring(0, 50));
        }

        // Test 3: Check if it's a different function name
        console.log('\n   Testing: isRegistered(address) returns (bool)');
        try {
            const abi3 = ['function isRegistered(address) view returns (bool)'];
            const contract3 = new ethers.Contract(CONTRACT_ADDRESS, abi3, provider);
            const result3 = await contract3.isRegistered(TEST_ADDRESS);
            console.log('   ✅ SUCCESS! Result:', result3);
        } catch (err) {
            console.log('   ❌ FAILED:', err.code || err.message.substring(0, 50));
        }

        // Test 4: identityOwner(address)
        console.log('\n   Testing: identityOwner(address) returns (address)');
        try {
            const abi4 = ['function identityOwner(address) view returns (address)'];
            const contract4 = new ethers.Contract(CONTRACT_ADDRESS, abi4, provider);
            const result4 = await contract4.identityOwner(TEST_ADDRESS);
            console.log('   ✅ SUCCESS! Result:', result4);
        } catch (err) {
            console.log('   ❌ FAILED:', err.code || err.message.substring(0, 50));
        }

        // Step 5: Get Transaction History
        console.log('\n📜 Step 5: Checking Recent Transactions');
        const currentBlock = await provider.getBlockNumber();
        const fromBlock = Math.max(0, currentBlock - 100);

        try {
            const logs = await provider.getLogs({
                address: CONTRACT_ADDRESS,
                fromBlock: fromBlock,
                toBlock: 'latest'
            });
            console.log('   📊 Found', logs.length, 'events in last 100 blocks');
            if (logs.length > 0) {
                console.log('   📝 Recent event topics:');
                logs.slice(0, 3).forEach((log, i) => {
                    console.log(`      ${i + 1}. ${log.topics[0]}`);
                });
            }
        } catch (err) {
            console.log('   ⚠️  Could not fetch logs:', err.message);
        }

        // Step 6: Manual Call Test
        console.log('\n🧪 Step 6: Manual eth_call Test');
        try {
            // Method signature for changed(address): 0xf96d0f9f
            const data = '0xf96d0f9f' + TEST_ADDRESS.substring(2).padStart(64, '0');
            console.log('   📤 Call Data:', data);

            const result = await provider.call({
                to: CONTRACT_ADDRESS,
                data: data
            });
            console.log('   ✅ Raw Response:', result);
        } catch (err) {
            console.log('   ❌ Call Failed:', err.message);
            console.log('   ⚠️  This confirms the contract method reverts');
        }

        console.log('\n' + '='.repeat(50));
        console.log('🎯 DIAGNOSIS COMPLETE\n');

    } catch (error) {
        console.error('\n❌ Fatal Error:', error.message);
        console.error(error);
    }
}

// Run diagnostics
diagnoseContract().catch(console.error);