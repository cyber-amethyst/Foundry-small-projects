// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Custom errors
error AgeRegistry__AgeTooHigh();
error AgeRegistry__AlreadyRegistered();

// I want to create a contract that allows a user to register their age, and then review the users whose age are below 10 years old.

contract AgeRegistry {
    mapping(address => bool) private registered;
    mapping(address => uint256) private userAge;

    //function to register the user
    function register(address user, uint256 age) external {
        if (age >= 18) revert AgeRegistry__AgeTooHigh();
        if (registered[user]) revert AgeRegistry__AlreadyRegistered();

        registered[user] = true;
        userAge[user] = age;
    }
    //function to register yourself

    function registerMyself(uint256 age) external {
        if (age >= 18) revert AgeRegistry__AgeTooHigh();
        if (registered[msg.sender]) revert AgeRegistry__AlreadyRegistered();

        registered[msg.sender] = true;
        userAge[msg.sender] = age;
    }

    function isRegistered(address user) external view returns (bool) {
        return registered[user];
    }

    //function to view the age of user now
    function getUserAge(address user) external view returns (uint256) {
        return userAge[user];
    }

    function getMyAge() external view returns (uint256) {
        return userAge[msg.sender];
    }
}
