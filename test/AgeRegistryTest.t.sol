// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {AgeRegistry, AgeRegistry__AgeTooHigh} from "../src/AgeRegistry.sol";

contract AgeRegistryTest is Test {
    AgeRegistry public registry;
    address internal user = makeAddr("user");

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

    function testRevertRegisterMyselfWhenAgeIs18()external{
        vm.expectRevert(AgeRegistry__AgeTooHigh.selector);
        vm.prank(user);
        registry.registerMyself(18);
    }
}

