const { ethers } = require("ethers");
require('dotenv').config();

const address  = "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5";
const apiKey  = process.env.API_KEY;
const https = require('https');

/**
 *
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

getAccountBalance(address, apiKey, https);

