//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface IMdNFT is IERC721, IERC721Enumerable {
    struct Auction {
        uint256 startTime;
        uint256 endTime;
        uint256 currentBid;
        address owner;
        address currentBidder;
    }

    function mintValidTarget() external returns(uint256);

    function burn(uint256 tokenId) external;
}