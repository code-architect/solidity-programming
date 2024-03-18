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

    describe("Deployment", () => {
        // check unlock time
        it("Should check unlock time", async () => {
            const {myTest, unlockedTime} = await loadFixture(runEveryTime);
            expect(await myTest.unlockedTime()).to.equal(unlockedTime);
        });

        it("Should set the right owner", async () => {
            const {myTest, owner} = await loadFixture(runEveryTime);
            expect(await myTest.owner()).to.equal(owner.address);
        });

        it('should receive and store the funds to MyTest', async () => {
            const {myTest, lockedAmount} = await loadFixture(runEveryTime);
            expect(await ethers.provider.getBalance(myTest.address)).to.equal(lockedAmount);
        });
    });
    
    describe("Condition", () =>{
        it('should fail if the unlocked is not in the future', async() => {
            const latestTime = await time.latest();
            const MyTest = await ethers.getContractFactory("MyTest");
            await expect(MyTest.deploy(latestTime, {value: 1})).to.be.revertedWith("The time should be in future");
        });

        it('should revert with the right if called too soon', async() => {
            const {myTest} = await loadFixture(runEveryTime);
            expect(myTest.withdraw()).to.be.revertedWith("Wait for the time period to be completed");
        });

        it('should revert with the right if called by anyone else but the owner', async() => {
            const {myTest, unlockedTime, otherAccount} = await loadFixture(runEveryTime);
            await time.increaseTo(unlockedTime);
            expect(myTest.connect(otherAccount).withdraw()).to.be.revertedWith("You are not an owner");
        });

        it('should not fail if its the unlock time and the owner has called it', async() => {
            const {myTest, unlockedTime} = await loadFixture(runEveryTime);
            await time.increaseTo(unlockedTime);
            await expect(myTest.withdraw()).not.to.be.reverted;
        });
    });

    describe("EVENTS", async () => {
        it('should emit the event on withdrawal', async () => {
            const {myTest, unlockedTime, lockedAmount} = await loadFixture(runEveryTime);
            await time.increaseTo(unlockedTime);
            await expect(myTest.withdraw()).to.emit(myTest, "Withdrawal");
        });

        it('should transfer the amount', async () => {
            const {myTest, unlockedTime, lockedAmount, owner} = await loadFixture(runEveryTime);
            await time.increaseTo(unlockedTime);
            await expect(myTest.withdraw()).to.changeEtherBalances([owner, myTest], [lockedAmount, -lockedAmount]);
        });
    });

    runEveryTime();
});