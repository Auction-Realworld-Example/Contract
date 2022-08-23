// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./IMdNFT.sol";

/**
1) function openAuction
2) function closeAuction. If close Auction, define the winner and transfer NFT to winner
3) function placeBid. If place bid, you have to bid more than current bid, when you bid 
you are using MDT to pay for the bid
How to implement
create a struct Auction {
    startTime,
    endTime,
    currentBid,
    nftId,
    owner
}

*/
contract MdAuction is Ownable, IERC721Receiver {
    enum AuctionState {
        OPENED,
        EXPIRED,
        CLOSED
    }
    struct Auction {
        uint256 nftID;
        uint256 startTime;
        uint256 endTime;
        uint256 currentBid;
        address currentBidder;
    }
    IERC20 private standardToken;
    IMdNFT private standardNFT;
    uint256 public entranceFee = 5 * 10**12; // here is 0.000005 ether
    mapping(uint16 => Auction) public auctions;
    uint16 auctionLength;
    mapping(address => uint256) public tokenBalances; // each address will have money back if their bid is lose
    uint256 public durationAuction = 60 * 20; // 20 minutes for bidding when open auction
    uint256 public balances;
    AuctionState public contractState;

    event newAuctionOpened(uint256 nftID, uint256 startTime, uint256 endTime);
    event newAuctionClosed(uint256 nftID, address newOwner, uint256 finalPrice);
    event newPlaceBid(uint256 nftID, address bidder, uint256 bidPrice);

    /**
     * @dev Receive BNB. msg.data is empty
     */
    receive() external payable {}

    /**
     * @dev Receive BNB. msg.data is not empty
     */
    fallback() external payable {
        balances += msg.value;
    }

    constructor(address _standardToken, address _standardNFT) {
        standardToken = IERC20(_standardToken);
        standardNFT = IMdNFT(_standardNFT);
    }

    modifier isPeriod() {
        require(
            block.timestamp >= auctions[auctionLength - 1].endTime,
            "MdAuction: You only can withdraw your balances after end of current auction!"
        );
        _;
    }

    function setStandardToken(address _standardToken) public onlyOwner {
        standardToken = IERC20(_standardToken);
    }

    function setStandardNFT(address _standardNFT) public onlyOwner {
        standardNFT = IMdNFT(_standardNFT);
    }

    function setEntranceFee(uint256 _entranceFee) public onlyOwner {
        entranceFee = _entranceFee;
    }

    function setDurationAuction(uint256 _durationAuction) public onlyOwner {
        durationAuction = _durationAuction;
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    /**
        @dev admin can withdraw from this auction
    */
    function withdraw() public onlyOwner {
        (bool success, ) = payable(_msgSender()).call{value: balances}("");
        require(success, "Withdraw failed!");
    }

    function openAuction() public onlyOwner {
        uint256 nftCurrentLength;
        require(
            checkStatus() == uint8(AuctionState.CLOSED),
            "MdAuction: Auction is not closed!"
        );
        nftCurrentLength = uint256(standardNFT.mintValidTarget());
        auctions[auctionLength] = Auction(
            nftCurrentLength - 1,
            block.timestamp,
            block.timestamp + durationAuction,
            0,
            address(0)
        );
        auctionLength += 1;
        contractState = AuctionState.OPENED;
        emit newAuctionOpened(
            nftCurrentLength - 1,
            auctions[auctionLength - 1].startTime,
            auctions[auctionLength - 1].endTime
        );
    }

    function closeAuction() public onlyOwner {
        require(
            checkStatus() == uint8(AuctionState.EXPIRED),
            "MdAuction: This is not time to close Auction!"
        );
        if (auctions[auctionLength - 1].currentBid > 0) {
            standardNFT.safeTransferFrom(
                address(this),
                auctions[auctionLength - 1].currentBidder,
                auctions[auctionLength - 1].nftID
            );
        } else {
            standardNFT.burn(auctions[auctionLength - 1].nftID);
        }
        contractState = AuctionState.CLOSED;
        emit newAuctionClosed(
            auctions[auctionLength - 1].nftID,
            auctions[auctionLength - 1].currentBidder,
            auctions[auctionLength - 1].currentBid
        );
    }

    function placeBid(uint256 _amount) public payable {
        bool success;
        require(
            checkStatus() == uint8(AuctionState.OPENED),
            "MdAuction: You can only bid when auction is opened!"
        );
        require(
            msg.value >= entranceFee,
            "MdAuction: Please input fee more than 0.000005 ether!"
        );
        require(
            _amount > auctions[auctionLength - 1].currentBid,
            "MdAuction: Please bid higher than current bid!"
        );
        balances += msg.value;
        uint256 allowance = standardToken.allowance(msg.sender, address(this));
        require(allowance >= _amount, "MdAuction: Over allowance of bid");
        success = standardToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(success, "MdAuction: Fail to transfer Muti Deactive Token!");
        if (auctions[auctionLength - 1].currentBid != 0) {
            // that means there is this session has bidder
            success = standardToken.transfer(
                auctions[auctionLength - 1].currentBidder,
                auctions[auctionLength - 1].currentBid
            );
            require(success, "MdAuction: Can not transfer token to loser!");
        }
        auctions[auctionLength - 1].currentBid = _amount;
        auctions[auctionLength - 1].currentBidder = msg.sender;
        emit newPlaceBid(
            auctions[auctionLength - 1].nftID,
            auctions[auctionLength - 1].currentBidder,
            auctions[auctionLength - 1].currentBid
        );
    }

    function checkStatus() public view returns (uint8) {
        if (auctionLength == 0) {
            return uint8(AuctionState.CLOSED);
        } else if (
            block.timestamp > auctions[auctionLength - 1].endTime &&
            contractState == AuctionState.OPENED
        ) {
            return uint8(AuctionState.EXPIRED);
        } else {
            return uint8(contractState);
        }
    }

    // for testing
    function changeStatus(uint8 _status) public {
        if (_status == 1) {
            contractState = AuctionState.EXPIRED;
        } else if (_status == 0) {
            contractState = AuctionState.OPENED;
        } else {
            contractState = AuctionState.CLOSED;
        }
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
