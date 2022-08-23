const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
	expectRevert,
	send,
	time, // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");
describe("MdNFT Testing", function () {
	let FDT;
	let owner;
	let addr1;
	let addr2;
	let addrs;
	let tokenContract;
	beforeEach(async function () {
		[owner, addr1, addr2, ...addrs] = await ethers.getSigners();
		const MdToken = await ethers.getContractFactory("MdNFT");
		tokenContract = await MdToken.deploy("https://localhost:3000/");
	});
	it("After deployment", async () => {
		const tokenAddress = tokenContract.address;
		console.log("NFT address is ", tokenAddress);
	});
	it("Try to get image link", async () => {
		const uri = await tokenContract.getBaseUri(15);
		expect(uri).to.be.equal("https://localhost:3000/15.jpg");
	});
	it("Set valid target and minting", async () => {
		await tokenContract.setValidTarget(addr1.address, true);
		await tokenContract.connect(addr1).mintValidTarget(200);
		expect(await tokenContract.balanceOf(addr1.address)).to.be.equal(200);
		await expectRevert.unspecified(
			tokenContract.connect(addr1).mintValidTarget(5000)
		);
		await expectRevert.unspecified(
			tokenContract.connect(addr2).mintValidTarget(200)
		); // fail due to not set valid target
	});
});
