const hre = require("hardhat");

async function main() {
	// const MdNFT = await ethers.getContractFactory("MdNFT");
	// const nftContract = await MdNFT.deploy();
	// const MdToken = await ethers.getContractFactory("MdToken");
	// const tokenContract = await MdToken.deploy();
	const MdAuction = await ethers.getContractFactory("MdAuction");
	const auctionContract = await MdAuction.deploy(
		"0x4b99b0B11e6a88Ea229040940958bb4E46e5E4Ea",
		"0xc48A3bD0Ab7021FF1A640e59b4177FBFe22FA3Ec"
	);
	// await nftContract.deployed();
	// await tokenContract.deployed();
	await auctionContract.deployed();
	// await nftContract.setValidTarget(auctionContract.address, true);
	// console.log("Token deployed to:", tokenContract.address);
	// console.log("NFT deployed to:", nftContract.address);
	console.log("Auction deployed to:", auctionContract.address);
	//BSC TESTNET
	// Token deployed to: 0x4b99b0B11e6a88Ea229040940958bb4E46e5E4Ea
	// NFT deployed to: 0xc48A3bD0Ab7021FF1A640e59b4177FBFe22FA3Ec
	// Auction deployed to: 0x93d59257BB4D02D672CFfc4EA3f381C58137f533
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
