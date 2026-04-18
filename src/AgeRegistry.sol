// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


// Custom errors
    error AgeRegistry__AgeTooHigh();

// I want to create a contract that allows a user to register their age, and then review the users whose age are below 10 years old.
contract AgeRegistry {

    mapping(address => bool) private registered;

//function to register the user
    function register(address user, uint256 age) external {
        if (age >= 18) revert AgeRegistry__AgeTooHigh();

        registered[user] = true;
    }
//function to register yourself
    function registerMyself(uint256 age) external {
        if (age >= 18) revert AgeRegistry__AgeTooHigh();

        registered[msg.sender] = true;
    }

//function to view the age of user now
    function isRegistered(address user) external view returns(bool) {
        return registered[user];
    }
}