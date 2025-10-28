const fs = require("fs");
const path = require("path");
const readline = require("readline");
const keythereum = require("keythereum");

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

console.log("Keystore Private Key Extractor");
console.log("================================\n");

rl.question("Enter path to keystore file: ", (filePath) => {
    rl.question("Enter password: ", (password) => {
        try {
            const resolvedPath = path.resolve(filePath);
            const keyObject = JSON.parse(fs.readFileSync(resolvedPath, "utf8"));

            // Extract the directory of the keystore file
            const dir = path.dirname(resolvedPath);

            // Use keythereum to recover the private key
            const privateKey = keythereum.recover(password, keyObject);

            console.log("\n✓ Private key extracted successfully:");
            console.log("0x" + privateKey.toString("hex"));
        } catch (err) {
            console.error("\n✗ Failed to extract private key:", err.message);
            console.error("Make sure the password and keystore file are correct.\n");
        } finally {
            rl.close();
        }
    });
});
