// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {MembersVault} from "../src/MembersVault.sol";

contract MembersVaultTest is Test {
    MembersVault public membersVault;
    address internal user = makeAddr("user");
    address internal user2 = makeAddr("user2");

    function setUp() external {
        membersVault = new MembersVault();
    }

    function test_RegisterMemberWhenUserRegisters() external {
        vm.prank(user);
        membersVault.registerMember();
        bool isMember = membersVault.isMember(user);
        assertEq(isMember, true); // assert that the user is a member
        // assertEq(membersVault.isMember(user) == true); // another way to write it
    }

    function test_RevertsWhenNonMemberMakesADeposit() external {
        vm.deal(user, 1 ether);
        vm.expectRevert(MembersVault.MembersVault__NotAMember.selector);
        vm.prank(user);
        membersVault.deposit{value: 0.5 ether}();
    }

    function test_BalanceIncreasesWhenAMemberDeposits() external {
        vm.deal(user, 2 ether);
        vm.startPrank(user);
        membersVault.registerMember();
        membersVault.deposit{value: 1 ether}();
        vm.stopPrank();
        assertEq(membersVault.getBalance(user), 1 ether);
    }

    function test_BalanceDecreasesWhenMemberMakesAWithdrawal() external {
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        membersVault.registerMember();
        membersVault.deposit{value: 1 ether}();
        membersVault.withdraw(0.7 ether);
        vm.stopPrank();
        assertEq(membersVault.getBalance(user), 0.3 ether);
    }

    function test_RevertsWhenWithdrawAmountIsZero() external {
        vm.startPrank(user);
        membersVault.registerMember();
        vm.expectRevert(MembersVault.MembersVault__ZeroAmount.selector);
        membersVault.withdraw(0 ether);
        vm.stopPrank();
    }

    function test_RevertsWhenWithdrawExceedsBalance() external {
        vm.deal(user, 2 ether);
        vm.startPrank(user);
        membersVault.registerMember();
        membersVault.deposit{value: 1.5 ether}();
        vm.expectRevert(MembersVault.MembersVault__InsufficientBalance.selector);
        membersVault.withdraw(2.3 ether);
        vm.stopPrank();
    }

    function test_TheContractBalanceReflectsTotalDeposits() external {
        vm.deal(user, 1 ether);
        vm.deal(user2, 1 ether);

        vm.startPrank(user);
        membersVault.registerMember();
        membersVault.deposit{value: 0.5 ether}();
        vm.stopPrank();

        vm.startPrank(user2);
        membersVault.registerMember();
        membersVault.deposit{value: 0.4 ether}();
        vm.stopPrank();
        assertEq(membersVault.getContractBalance(), 0.9 ether);
    }
}
