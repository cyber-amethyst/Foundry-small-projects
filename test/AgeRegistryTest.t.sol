// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {AgeRegistry, AgeRegistry__AgeTooHigh, AgeRegistry__AlreadyRegistered} from "../src/AgeRegistry.sol";

contract AgeRegistryTest is Test {
    AgeRegistry public registry;
    address internal user = makeAddr("user");
    address internal user1 = makeAddr("user1");
    address internal user2 = makeAddr("user2");

    function setUp() external {
        registry = new AgeRegistry();
    }

    function testAllowsUserRegisterAtAge17() external {
        registry.register(user, 17);
        bool registered = registry.isRegistered(user);
        assertEq(registered, true);
    }

    function testDoesNotAllowUserRegisterAtAge18() external {
        vm.expectRevert(AgeRegistry__AgeTooHigh.selector);
        registry.register(user, 18);
    }

    function testDoesNotAllowUserRegisterAtAge19() external {
        vm.expectRevert(AgeRegistry__AgeTooHigh.selector);
        registry.register(user, 19);
    }

    function testAllowRegisterMyselfWhenAgeIs17() external {
        vm.prank(user);
        registry.registerMyself(17);
        bool registered = registry.isRegistered(user);
        assertEq(registered, true);
    }

    function testRevertRegisterMyselfWhenAgeIs18() external {
        vm.expectRevert(AgeRegistry__AgeTooHigh.selector);
        vm.prank(user);
        registry.registerMyself(18);
    }

    function test_StoresAgeAfterRegister() external {
        registry.register(user, 7);
        assertEq(registry.getUserAge(user), 7);
    }

    function test_StoreMyAgeAfterIRegisterMyself() external {
        vm.startPrank(user);
        registry.registerMyself(15);
        assertEq(registry.getMyAge(), 15);
        vm.stopPrank();
    }

    function test_UnregisteredUserReturns0InGetUserAge() external view {
        assertEq(registry.getUserAge(user), 0);
    }

    function test_AgeRevertsWhenAlreadyRegistered() external {
        registry.register(user, 17);
        vm.expectRevert(AgeRegistry__AlreadyRegistered.selector);
        registry.register(user, 17);
    }

    function test_AgeRevertsWhenAlreadyRegisteredMyself() external {
        vm.prank(user);
        registry.registerMyself(17);
        vm.expectRevert(AgeRegistry__AlreadyRegistered.selector);
        vm.prank(user);
        registry.registerMyself(17);
    }

    function test_TwoUsersCanRegisterIndependently() external {
        registry.register(user1, 12);
        registry.register(user2, 14);
        bool registered = registry.isRegistered(user1) && registry.isRegistered(user2);
        assertEq(registry.getUserAge(user1), 12);
        assertEq(registry.getUserAge(user2), 14);
        assertEq(registered, true);
    }
}
