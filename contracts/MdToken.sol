// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract MdToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Multi Deactive Token", "MDT") {
        mint(msg.sender, 10 ** 26);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}