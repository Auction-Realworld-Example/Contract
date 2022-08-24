// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MdToken is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor() ERC20("Muti Deactive", "MDT") ERC20Permit("Muti Deactive") {
      mint(msg.sender, 10 ** 26);
    }

    function mint(address to, uint256 amount) public onlyOwner{
        _mint(to, amount);
    }
}