// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PiggyBank} from "../src/PiggyBank.sol";

contract PiggyBankTest is Test {
    PiggyBank public piggyBank;
    address internal user = makeAddr("user");
    address internal user2 = makeAddr("user2");

    function setUp() external {
        piggyBank = new PiggyBank();
    }

    function test_BalanceUpdates_AfterDeposit() external {
        vm.deal(user, 1 ether);
        vm.prank(user);
        piggyBank.deposit{value: 0.5 ether}();
        assertEq(piggyBank.getBalance(user), 0.5 ether);
    }

    function test_BalanceReduces_AfterWithdraw() external {
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        piggyBank.deposit{value: 1 ether}();
        piggyBank.withdraw(0.4 ether);
        vm.stopPrank();
        assertEq(piggyBank.getBalance(user), 0.6 ether);
    }

    function test_Reverts_WhenWithdrawAmountIsZero() external {
        vm.expectRevert(PiggyBank.PiggyBank__ZeroAmount.selector);
        piggyBank.withdraw(0 ether);
    }

    function test_Reverts_WhenWithdrawExceedsBalance() external {
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        piggyBank.deposit{value: 0.5 ether}();
        vm.expectRevert(PiggyBank.PiggyBank__InsufficientBalance.selector);
        piggyBank.withdraw(1 ether);
        vm.stopPrank();
    }

    function test_ThatContractBalanceRflectsTotalDeposits() external {
        vm.deal(user, 1 ether);
        vm.deal(user2, 1 ether);

        vm.prank(user);
        piggyBank.deposit{value: 0.5 ether}();

        vm.prank(user2);
        piggyBank.deposit{value: 0.4 ether}();
        assertEq(piggyBank.getContractBalance(), 0.9 ether);
    }

    function test_ReceiveDepositsETH() external {
        vm.deal(user, 1 ether);
        vm.prank(user);
        (bool success,) = address(piggyBank).call{value: 0.5 ether}("");
        assertTrue(success);
        assertEq(piggyBank.getBalance(user), 0.5 ether);
    }
}
