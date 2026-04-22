// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract PiggyBank {
    mapping(address => uint256) private balances;
    error PiggyBank__ZeroAmount();
    error PiggyBank__InsufficientBalance();

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert PiggyBank__ZeroAmount();
        if (amount > balances[msg.sender]) revert PiggyBank__InsufficientBalance();
        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}
