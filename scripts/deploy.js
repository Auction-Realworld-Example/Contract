const hre = require("hardhat");

async function main() {
	// const MdNFT = await ethers.getContractFactory("MdNFT");
	// const nftContract = await MdNFT.deploy();
	const MdToken = await ethers.getContractFactory("MdToken");
	const tokenContract = await MdToken.deploy();
	// const MdAuction = await ethers.getContractFactory("MdAuction");
	// const auctionContract = await MdAuction.deploy(
	// 	"0x2888151aE14F1267d9495BF6DaD8cE80c50f3D4f",
	// 	"0x21bcf22790B6d66C2d1a23cd08a522418315Ce3e"
	// );
	// await nftContract.deployed();
	await tokenContract.deployed();
	// await auctionContract.deployed();
	// await nftContract.setValidTarget(
	// 	"0x6d61AC5ff5B0E5F86F60e8cf28708D5bf5691981",
	// 	true
	// );
	console.log("Token deployed to:", tokenContract.address);
	// console.log("NFT deployed to:", nftContract.address);
	// console.log("Auction deployed to:", auctionContract.address);
	//BSC TESTNET
	// Token deployed to: 0x861Dd54bE1CdC1bD93B3e1e678eF57B8F7AeA985
	// NFT deployed to: 0x21bcf22790B6d66C2d1a23cd08a522418315Ce3e
	// Auction deployed to: 0x87dCaE081479f527F3237e532fc3d2427113F77F
	// MUMBAI
	// Token deployed to: 0xa9497Fe60cF84723186EE04EB30a561784d4dd8c
	// NFT deployed to: 0x0B786e4b37dA7F57763f70282AAf5bF91dFE0b57
	// Auction deployed to: 0xDfCea27fC2440f98C70F86979DA9416284b506f1
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
