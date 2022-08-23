const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
	expectRevert,
	send,
	time, // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");
describe("MdToken Testing", function () {
	let FDT;
	let owner;
	let addr1;
	let addrs;
	let tokenContract;
	beforeEach(async function () {
		[owner, addr1, ...addrs] = await ethers.getSigners();
		const MdToken = await ethers.getContractFactory("MdToken");
		tokenContract = await MdToken.deploy();
	});
	it("After deployment", async () => {
		const tokenAddress = tokenContract.address;
		console.log("token address is ", tokenAddress);
	});
	it("Check minting NFT", async () => {
		expect(await tokenContract.balanceOf(owner.address)).to.be.equal(10 ** 8);
	});
	it("Can't minting if you are not owner", async () => {
		await expectRevert.unspecified(
			tokenContract.connect(addr1).mint(addr1?.address, 500)
		);
	});
});
