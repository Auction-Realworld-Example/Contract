// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract MdNFT is
    ERC721,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    Ownable,
    EIP712,
    ERC721Votes
{
    using Strings for uint256;
    using Counters for Counters.Counter;
    string public baseExtension = ".json";
    uint256 public maxSupply = 1000;
    mapping(address => bool) public validTargets;
    mapping(address => bool) public approvals;
    mapping(uint256 => bool) public nftIsBurned;
    Counters.Counter private _tokenIdCounter;

    constructor()
        ERC721("Multi Deactive NFT", "MT")
        EIP712("Multi Deactive NFT", "1")
    {}

    function setApproval(address _target, bool _permission) public onlyOwner {
        approvals[_target] = _permission;
    }

    function setValidTarget(address _target, bool _permission)
        public
        onlyOwner
    {
        validTargets[_target] = _permission;
    }

    function setBaseExtension(string memory baseExtension_) public onlyOwner {
        baseExtension = baseExtension_;
    }

    function mintValidTarget() public returns (uint256) {
        require(validTargets[msg.sender], "MdNFT: Not valid target!");
        require(
            _tokenIdCounter.current() + 1 <= maxSupply,
            "MdNFT: Overallowance supply!"
        );
        uint256 _tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_msgSender(), _tokenId);
        return _tokenIdCounter.current();
    }

    function setTokenUri(uint256 _tokenId, string memory _tokenUri)
        public
        onlyOwner
    {
        _setTokenURI(_tokenId, _tokenUri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Votes) {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "MdNFT: Not owner or approved by owner"
        );
        nftIsBurned[tokenId] = true;
        super._burn(tokenId);
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        require(totalSupply() < maxSupply, "MdNFT: Overallowance supply!");
        super._mint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
