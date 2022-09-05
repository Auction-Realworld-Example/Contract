require("@nomicfoundation/hardhat-toolbox");
const { metamaskKey } = require("./secrets");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	networks: {
		testnet: {
			url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
			accounts: [metamaskKey],
		},
		mainnet: {
			url: `https://bsc-dataseed.binance.org/`,
			accounts: [metamaskKey],
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
