// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Role.sol";

abstract contract RoleRestricted {
        function _toLower(string memory str) internal pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }

    function _areEqual(string memory a, string memory b) private pure returns (bool) {
        return keccak256(abi.encodePacked((_toLower(a)))) == keccak256(abi.encodePacked((_toLower(b))));
    }

    function toRole(string memory role) external pure returns (Role) {
        if (_areEqual(role, "backenddeveloper")) return Role.BackEndDeveloper;
        if (_areEqual(role, "frontenddeveloper")) return Role.FrontEndDeveloper;
        if (_areEqual(role, "projectmanager")) return Role.ProjectManager;
        if (_areEqual(role, "ceo")) return Role.CEO;
        if (_areEqual(role, "executive")) return Role.Executive;
        if (_areEqual(role, "designer")) return Role.Designer;
        return Role.None;
    }

    modifier onlyRole(Role role, Role permittedRole) {
        require (role == permittedRole);
        _;
    }
}