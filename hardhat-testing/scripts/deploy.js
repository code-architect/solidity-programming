const hre = require("hardhat");

// console.log(hre);

async function main() 
{
    const currentTimestampInSeconds = Math.random(Date.now() / 1000);
    const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    const unlockedTime = currentTimestampInSeconds + ONE_YEAR_IN_SECONDS;
    console.log(currentTimestampInSeconds);
    console.log(ONE_YEAR_IN_SECONDS);
    console.log(unlockedTime);

    
}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1;
});