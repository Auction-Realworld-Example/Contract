require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

let secrets = require("./secret.json");
module.exports = {
	defaultNetwork: "hardhat",
	networks: {
		localhost: {
			url: "http://127.0.0.1:8545",
		},
		hardhat: {
			chainId: 1337,
		},
		matic: {
			url: "https://rpc-mumbai.maticvigil.com",
			accounts: [secrets.key],
		},
		testnet: {
			url: "https://data-seed-prebsc-1-s1.binance.org:8545",
			chainId: 97,
			gasPrice: 20000000000,
			accounts: [secrets.key],
		},
		mainnet: {
			url: "https://bsc-dataseed.binance.org/",
			chainId: 56,
			gasPrice: 20000000000,
			accounts: [secrets.key],
		},
	},
	solidity: {
		version: "0.8.13",
		settings: {
			optimizer: {
				enabled: true,
				runs: 200,
			},
		},
	},
};
