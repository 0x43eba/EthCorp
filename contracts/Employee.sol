// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Role.sol";

struct Employee {
    uint256 level;
    string name;
    address wallet;
    string email;
    string kennitala;
    bool hasOffer;
    bool isEmployed;
    uint256 offerId;
    Role role;
}