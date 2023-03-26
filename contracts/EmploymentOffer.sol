// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./RoleRestricted.sol";
import "./Employable.sol";
import "./Employee.sol";

// Deploy me second
contract EmploymentOffer is ERC721, RoleRestricted, Employable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private _owner;
    mapping(address => Employee) private _candidates;

    constructor(address owner) ERC721("EmploymentOffer", "EMO") {
        _owner = owner;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "not contract owner");
        _;
    }

    modifier candidateIsCaller(address candidate) {
        require(msg.sender == candidate, "candidate is not caller");
        _;
    }

    modifier onlyCandidateOrOwner(address candidate) {
        require(_candidates[candidate].hasOffer || msg.sender == _owner, "not a candidate");
        _;
    }

    function mint(
        address candidate,
        string memory kennitala,
        string memory name,
        string memory email,
        string memory role,
        uint256 level
    ) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(candidate, tokenId);
        _candidates[candidate] = Employee({
            name: name,
            email: email,
            level: level,
            kennitala: kennitala,
            isEmployed: false,
            hasOffer: true,
            role: this.toRole(role),
            offerId: tokenId,
            wallet: candidate
        });
        return tokenId;
    }

    // Expected to be called remotely, not from Company contract
    // Can not be burned from the contract, but will be unable to be
    // used again, as the contract sets the hasOffer to false.
    function burn(address caller) public onlyCandidateOrOwner(caller) candidateIsCaller(caller) {
        _burn(_candidates[caller].offerId);
        Employee memory emp = _candidates[caller];
        emp.hasOffer = false;
        _candidates[caller] = this._nullEmployeeFactory();
    }


    function getCandidate(address candidate) public view returns(Employee memory) {
        return _candidates[candidate];
    }

}