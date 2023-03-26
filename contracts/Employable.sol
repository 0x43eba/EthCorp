// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Employee.sol";
import "./Role.sol";

abstract contract Employable {
    function _nullEmployeeFactory() external pure returns (Employee memory) {
        string memory empty = "";
        return Employee({
            name: empty,
            kennitala: empty,
            email: empty,
            wallet: address(0),
            hasOffer: false,
            isEmployed: false,
            role: Role.None,
            offerId: 0,
            level: 0
        });
    }
}