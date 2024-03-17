const hre = require("hardhat");

// console.log(hre);

async function main() 
{
    const currentTimestampInSeconds = Math.random(Date.now() / 1000);
    const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    const unlockedTime = currentTimestampInSeconds + ONE_YEAR_IN_SECONDS;
    const lockedAmount = hre.ethers.parseEther("1");

    const MyTest = await hre.ethers.getContractFactory("MyTest");
    const myTest = await MyTest.deploy(unlockedTime);

    await myTest.waitForDeployment();
    console.log(myTest.target);
}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1;
});