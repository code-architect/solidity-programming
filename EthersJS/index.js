const { ethers } = require("ethers");
require('dotenv').config();

const address  = "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5";
const apiKey  = process.env.API_KEY;
const https = require('https');
const provider = new ethers.providers.EtherscanProvider("homestead", apiKey);

/**
 * Get the account balance
 * @param address user address
 * @param apiKey
 * @param https
 */
function getAccountBalance(address, apiKey, https)
{
    const url =`https://api.etherscan.io/api?module=account&action=balance&address=${address}&tag=latest&apikey=${apiKey}`;
    https.get(url, (res) => {
        let data = '';

        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('end', () => {
            try {
                const response = JSON.parse(data);
                const balance = response.result;
                console.log(`Account balance: ${balance}`);
            } catch (error) {
                console.error('Error parsing response:', error);
            }
        });

        res.on('error', (error) => {
            console.error('Error fetching balance:', error);
        });
    })
        .on('error', (error) => {
            console.error('Error creating request:', error);
        });
}


const defaultEtherscanFetchBalance = async (address, provider) => {

    const getBalancePromise = provider.getBalance(address);
    getBalancePromise.then((balance) => {
        const showTrueBalance = ethers.utils.formatEther(balance);
        console.log(`Account balance: ${showTrueBalance}`);
    }).catch((error) => {
        console.error('Error fetching balance:', error);
    });
};

const checkFunction = async (provider, blockNumber) =>
{
    const blockGet = await provider.getBlock(blockNumber);
    // console.log(JSON.stringify(blockGet, null, 2));
    const number = blockGet.number;
    console.log(number);
};

const transactionDetails = async (provider, blockNumber) =>
{
    const blockGet = await provider.getBlock(blockNumber);
    const number = blockGet.transactions;
    const jsonData = JSON.stringify(number, null, 2); // Pretty-printed JSON
    const fs = require('fs');
    fs.writeFile('data.json', jsonData, (err) => {
        if (err) {
            console.error('Error writing file:', err);
        } else {
            console.log('JSON data saved successfully!');
        }
    });
}

transactionDetails(provider,19445346);