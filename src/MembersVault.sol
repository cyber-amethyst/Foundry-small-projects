// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract MembersVault {
    error MembersVault__NotAMember();
    error MembersVault__InsufficientBalance();
    error MembersVault__ZeroAmount();
    error MembersVault__IsAlreadyAMember();

    event MemberRegistered(address indexed member);
    event Deposited(address indexed member, uint256 amount);
    event Withdrawn(address indexed member, uint256 amount);

    mapping(address => bool) private members;
    mapping(address => uint256) private balances;

    function registerMember() external {
        if (members[msg.sender]) revert MembersVault__IsAlreadyAMember();
        members[msg.sender] = true;
        emit MemberRegistered(msg.sender);
    }

    function deposit() external payable {
        if (!members[msg.sender]) revert MembersVault__NotAMember();
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        // Checks
        if (!members[msg.sender]) revert MembersVault__NotAMember();
        if (amount == 0) revert MembersVault__ZeroAmount();
        if (amount > balances[msg.sender]) revert MembersVault__InsufficientBalance();
        // Effects
        balances[msg.sender] -= amount;
        emit Withdrawn(msg.sender, amount);
        //Interaction
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");
    }

    // READ FUNCTIONS

    function isMember(address user) external view returns (bool) {
        return members[user];
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
