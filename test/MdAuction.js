const { expect } = require("chai");
const { ethers } = require("hardhat");
const { expectRevert } = require("@openzeppelin/test-helpers");
describe("MdNFT Testing", function () {
	let owner;
	let addr1;
	let addr2;
	let addrs;
	let nftContrdact;
	let auctionContract;
	let tokenContract;
	beforeEach(async function () {
		[owner, addr1, addr2, ...addrs] = await ethers.getSigners();
		const MdNFT = await ethers.getContractFactory("MdNFT");
		nftContract = await MdNFT.deploy("https://localhost:3000/");
		const MdToken = await ethers.getContractFactory("MdToken");
		tokenContract = await MdToken.deploy();
		const MdAuction = await ethers.getContractFactory("MdAuction");
		auctionContract = await MdAuction.deploy(
			tokenContract.address,
			nftContract.address
		);
		await nftContract.setValidTarget(owner.address, true);
		await nftContract.setValidTarget(addr1.address, true);
		await nftContract.setValidTarget(auctionContract.address, true);
	});
	it("After deployment", async () => {
		console.log("NFT address is ", nftContract.address);
		console.log("Auction address is ", auctionContract.address);
		console.log("Token address is ", tokenContract.address);
	});
	it("Open auction successfully", async () => {
		const openAuctionHandler = await auctionContract.openAuction();
		const tx = await openAuctionHandler.wait();
		/**
		 * Start bidding
		 */
		await tokenContract.mint(addr1.address, 1000000);
		await tokenContract.connect(addr1).approve(auctionContract.address, 5000);
		await auctionContract.connect(addr1).placeBid(5000, {
			value: ethers.utils.parseEther("0.000005"),
		});
		expectRevert(
			auctionContract.connect(owner).placeBid(2000, {
				value: ethers.utils.parseEther("0.000005"),
			}),
			"MdAuction: Please bid higher than current bid!"
		);
		await tokenContract.mint(addr2.address, 1000000);
		await tokenContract.connect(addr2).approve(auctionContract.address, 100000);
		await auctionContract.connect(addr2).placeBid(100000, {
			value: ethers.utils.parseEther("0.000005"),
		});
		expect(parseInt(await auctionContract.balances())).to.be.eq(10000000000000);
		// console.log(time.duration.minutes(20).toString());
		await auctionContract.changeStatus(1);
		expect(await auctionContract.checkStatus()).to.be.eq(1);
		await auctionContract.closeAuction();
		expect(await nftContract.ownerOf(0)).to.be.eq(addr2.address);
	});
	it("Open auction successfully", async () => {
		const openAuctionHandler = await auctionContract.openAuction();
		const tx = await openAuctionHandler.wait();
		/**
		 * Start bidding
		 */
		await tokenContract.mint(addr1.address, 1000000);
		await tokenContract.connect(addr1).approve(auctionContract.address, 5000);
		await auctionContract.connect(addr1).placeBid(5000, {
			value: ethers.utils.parseEther("0.000005"),
		});
		expectRevert(
			auctionContract.connect(owner).placeBid(2000, {
				value: ethers.utils.parseEther("0.000005"),
			}),
			"MdAuction: Please bid higher than current bid!"
		);
		await tokenContract.mint(addr2.address, 1000000);
		await tokenContract.connect(addr2).approve(auctionContract.address, 100000);
		await auctionContract.connect(addr2).placeBid(100000, {
			value: ethers.utils.parseEther("0.000005"),
		});
		expect(parseInt(await auctionContract.balances())).to.be.eq(10000000000000);
		/**
		 * End Place bid
		 */
		// console.log(time.duration.minutes(20).toString());
		await auctionContract.changeStatus(1);
		expect(await auctionContract.checkStatus()).to.be.eq(1);
		await auctionContract.closeAuction();
		expect(await nftContract.ownerOf(0)).to.be.eq(addr2.address);
		/** Check if close can open again ? */
		await auctionContract.openAuction();
		await tokenContract.connect(addr1).approve(auctionContract.address, 5000);
		await auctionContract.connect(addr1).placeBid(5000, {
			value: ethers.utils.parseEther("0.000005"),
		});
	});

	it("Open auction and not bid check burn token", async () => {
		const openAuctionHandler = await auctionContract.openAuction();
		const tx = await openAuctionHandler.wait();
		await auctionContract.changeStatus(1);
		expect(await auctionContract.checkStatus()).to.be.eq(1);
		await auctionContract.closeAuction();
		expect(await nftContract.nftIsBurned(0)).to.be.eq(true);
	});
});
