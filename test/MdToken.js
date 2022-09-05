const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MdToken Testing", () => {
	let owner;
	let addr1;
	let addrs;
	let tokenContract;
	beforeEach(async () => {
		[owner, addr1, ...addrs] = await ethers.getSigners();
		let tokenFactory = await ethers.getContractFactory("MdToken");
		tokenContract = await tokenFactory.deploy();
	});
	it("Deploy smart contract successfully, and give it address", async () => {
		console.log(tokenContract.address);
	});
	it("Show that totalSupply is 10^26 and that is equal to balanceOf owner", async () => {
		const ownerAmount = await tokenContract.balanceOf(owner.address);
		const totalSupply = await tokenContract.totalSupply();
		expect(ownerAmount).to.be.eq(totalSupply);
	});
	it("When you are minting token, it will fail if you are different account", async () => {
		const tx = tokenContract.connect(addr1).mint(addr1.address, 5000);
		await expect(tx).to.be.reverted;
	});
});
