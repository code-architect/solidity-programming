const {time, loadFixture} = require("@nomicfoundation/hardhat-network-helpers");
const {anyValue} = require("@nomicfoundation/hardhat-chai-matchers");
const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("MyTest", () => {
    async function runEveryTime()
    {
        const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
        const ONE_GEWI = 1000000000;
        const lockedAmount = ONE_GEWI;
        const unlockedTime = (await time.latest()) + ONE_YEAR_IN_SECONDS;

        // get accounts
        const [owner, otherAccount] = await ethers.getSigners();

        const  MyTest = await ethers.getContractFactory("MyTest");
        const myTest = await MyTest.deploy(unlockedTime, {value: lockedAmount});

        return {myTest, unlockedTime, lockedAmount, owner, otherAccount};
    }
    

    runEveryTime();
});