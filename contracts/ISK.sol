// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "hardhat/console.sol";

import "./Employee.sol";

// Upgradable contract
// Deploy me last. Need to limit this to only callable from the contract somehow
contract ISK is ERC20Upgradeable {
    address private _controllingAddress;

    modifier onlyController() {
        require(msg.sender == _controllingAddress, "only the controller can issue ATLI");
        _;
    }

    function initialize() public initializer {
        __ERC20_init("Kronur", "ISK");
    }

    constructor(address controllingContract)  {
        _controllingAddress = controllingContract;
    }

    function mint(address employee, uint256 ammount) external onlyController {
        _mint(employee, ammount);
    }
}