// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {AgeRegistry} from "../src/AgeRegistry.sol";

contract DeployAgeRegistry is Script {
    function run() external returns (AgeRegistry) {
        vm.startBroadcast();
        AgeRegistry registry = new AgeRegistry();
        vm.stopBroadcast();
        return registry;
    }
}
