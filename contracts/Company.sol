// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./EmploymentOffer.sol";
import "./EmploymentContract.sol";
import "./ISK.sol";
import "./Employee.sol";

// Deploy me fourth
contract Company {
    address private _owner;
    EmploymentContract private _employmentContract;
    EmploymentOffer private _employmentOffer;
    ISK public isk;

    modifier onlyEmployeeWithBurnedOffer() {
        require( _employmentContract.isEmployed(msg.sender), "not an employee");
        // Prevent employees from doing anything until they burn their offer
        // token. This prevents self-rehiring after termination.
        require(!_employmentOffer.getCandidate(msg.sender).hasOffer, "can not have EMC token and EMO token, burn EMO token");
        _;
    }

    constructor(address employmentContract, address employmentOffer) {
        _owner = msg.sender;
        _employmentOffer = EmploymentOffer(employmentOffer);
        _employmentContract = EmploymentContract(employmentContract);
        isk = new ISK(address(this));
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function mintISK() public onlyEmployeeWithBurnedOffer {
        uint256 level = _employmentContract.getLevel(msg.sender);
        uint256 curentBalance = isk.balanceOf(msg.sender);
        require(level > curentBalance, "you can not mint more ATLI than your level");
        uint256 delta = level - curentBalance;
        isk.mint(msg.sender, delta);
    }

}