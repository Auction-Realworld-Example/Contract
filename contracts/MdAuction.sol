// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./IMdNFT.sol";

/**
1) function openAuction: 
  - mint a new NFT
  - everybody will place bid to gain this nft
2) function closeAuction. 
  - when close the auction, the nft will be transfer to the highest bidder
3) function placeBid. 
  - put an entranceFee, it will be a fee for us to pay fee for run autotask
  - when a new bidder come, the token (MDT token) will be transfered to the
  previous bidder
*/
contract MdAuction is Ownable, IERC721Receiver {
    // MdNFT contract so we need an interface of MdNFT
    enum AuctionState {
        OPENED,
        EXPIRED,
        CLOSED
    } // 0,1,2 respectively
    struct Auction {
        uint256 nftId;
        uint256 startTime;
        uint256 endTime;
        uint256 currentBid;
        address currentBidder;
    }
    mapping(uint256 => Auction) public auctions;
    uint256 public auctionLength;
    IERC20 standardToken;
    IMdNFT standardNFT;
    uint256 public durationAuction = 20 * 60; // 20 minutes
    uint256 balances;
    uint256 public entranceFee = 5 * 10**12; //0.000005 eth
    AuctionState public contractState;

    event newAuctionOpened(uint256 nftId, uint256 startTime, uint256 endTime);
    event newAuctionClosed(uint256 nftId, address newOwner, uint256 finalPrice);
    event newPlaceBid(uint256 nftId, address bidder, uint256 bidPrice);

    constructor(address _token, address _nft) {
        standardToken = IERC20(_token);
        standardNFT = IMdNFT(_nft);
    }

    // Receive token BNB/ETH, msg.data is empty
    receive() external payable {
        balances = balances + msg.value;
    }

    // Receive token BNB/ETH, msg.data is not empty
    fallback() external payable {
        balances = balances + msg.value;
    }

    function setStandardToken(address _token) public onlyOwner {
        standardToken = IERC20(_token);
    }

    function setStandardNFT(address _nft) public onlyOwner {
        standardNFT = IMdNFT(_nft);
    }

    function getBalances() public view onlyOwner returns (uint256) {
        return balances;
    }

    function openAuction(string memory _uri) public onlyOwner {
        require(
            checkStatus() == uint8(AuctionState.CLOSED),
            "MdAuction: Auction state must be closed to be open a new session"
        );
        // Precondition: contractState = CLOSED
        uint256 nftId = standardNFT.mintValidTarget(address(this), _uri);
        auctions[auctionLength] = Auction(
            nftId,
            block.timestamp,
            block.timestamp + durationAuction,
            0,
            address(this)
        );
        auctionLength += 1; // now we go to new session of auction
        contractState = AuctionState.OPENED;
        emit newAuctionOpened(
            nftId,
            auctions[auctionLength - 1].startTime,
            auctions[auctionLength - 1].endTime
        );
    }

    function closeAuction() public onlyOwner {
        // Precondition: contractState = EXPIRED
        // transfer nft to new owner
        // change contractState to CLOSED
        require(
            checkStatus() == uint8(AuctionState.EXPIRED),
            "MdAuction: The session is not expired"
        );
        if (auctions[auctionLength - 1].currentBid > 0) {
            // if anyone bid for this session, the currentBid will greater than 0
            standardNFT.safeTransferFrom(
                address(this),
                auctions[auctionLength - 1].currentBidder,
                auctions[auctionLength - 1].nftId
            );
        } else {
            standardNFT.burn(auctions[auctionLength - 1].nftId);
        }
        contractState = AuctionState.CLOSED;
        emit newAuctionClosed(
            auctions[auctionLength - 1].nftId,
            auctions[auctionLength - 1].currentBidder,
            auctions[auctionLength - 1].currentBid
        );
    }

    function placeBid(uint256 _amount) public payable {
        require(
            checkStatus() == uint8(AuctionState.OPENED),
            "MdAuction: You only can place bit when auction is opened!"
        );
        require(
            msg.value >= entranceFee,
            "MdAuction: You have to put more than 0.000005 eth"
        );
        require(
            _amount > auctions[auctionLength - 1].currentBid,
            "MdAuction: You have to bid more than current bid"
        );
        balances += msg.value;
        uint256 allowance = standardToken.allowance(msg.sender, address(this));
        require(allowance >= _amount, "MdAuction: MdToken Overallowance");
        bool success = standardToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(success, "MdAuction: fail to transfer Md Token");
        if (auctions[auctionLength - 1].currentBid > 0) {
            // there exists previous bidder
            success = standardToken.transfer(
                auctions[auctionLength - 1].currentBidder,
                auctions[auctionLength - 1].currentBid
            );
            require(
                success,
                "MdAuction: can't not transfer to previous bidder"
            );
        }
        auctions[auctionLength - 1].currentBid = _amount;
        auctions[auctionLength - 1].currentBidder = msg.sender;
        emit newPlaceBid(
            auctions[auctionLength - 1].nftId,
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
            // That means we reach endTime and that mean we cant place bid because the current auction session is expired
            return uint8(AuctionState.EXPIRED);
        } else {
            return uint8(contractState);
        }
    }

    // TESTING
    function changeState(uint8 _state) public onlyOwner {
        if (_state == 0) {
            contractState = AuctionState.OPENED;
        } else if (_state == 1) {
            contractState = AuctionState.EXPIRED;
        } else {
            contractState = AuctionState.CLOSED;
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
