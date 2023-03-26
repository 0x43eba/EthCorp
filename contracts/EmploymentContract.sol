// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Employee.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./Employee.sol";
import "./EmploymentOffer.sol";
import "./Employable.sol";

// Deploy me third
contract EmploymentContract is ERC721, RoleRestricted, Employable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private _owner;
    EmploymentOffer private _offer;
    mapping(address => Employee) private _employees;

    constructor(address owner, address employmentOfferContract) ERC721("EmploymentContract", "EMC") {
        _owner = owner;
        _offer = EmploymentOffer(employmentOfferContract);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "not contract owner");
        _;
    }

    modifier onlyCandidate(address caller) {
        require(_offer.getCandidate(msg.sender).hasOffer && msg.sender == caller, "not a valid candidate");
        _;
    }

    modifier onlyEmployeeOrOwner(address caller) {
        require(_employees[caller].isEmployed || caller == _owner, "not employed");
        _;
    }

    modifier candidateIsCaller(address caller) {
        require(caller == msg.sender, "candidate is not sender");
        _;
    }

    // expects candidate to call this remotely, not from the gangverk contract
    function mint(address caller) public onlyCandidate(caller) returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(caller, tokenId);
        Employee memory emp = _offer.getCandidate(caller);
        emp.hasOffer = false;
        emp.isEmployed = true;
        _employees[caller] = emp;
        return tokenId;
    }

    function burn(address caller) public onlyEmployeeOrOwner(caller){
        _burn(_employees[caller].offerId);
        _employees[caller] = this._nullEmployeeFactory();
    }

    function isEmployed(address caller) public view returns (bool) {
        return _employees[caller].isEmployed;
    }

    // expects this to be called from the gangverk contract
    function getLevel(address caller) public view onlyEmployeeOrOwner(caller) returns (uint256) {
        return _employees[caller].level;
    }

}