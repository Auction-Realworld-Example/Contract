pragma solidity ^0.8.0;


// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


interface IMdNFT is IERC721 {
      function mintValidTarget(address to, string memory uri) external returns(uint256);
      function burn(uint256 tokenId) external;
}


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