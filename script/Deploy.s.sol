// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";

import { CasterFactory } from "@src/CasterFactory.sol";

contract Deploy is Script {
    address public s_feeReceiver;
    CasterFactory public s_factory;

    function run() public {
        s_feeReceiver = address(0x1); // Set the correct fee receiver here

        vm.startBroadcast();
        s_factory = new CasterFactory(s_feeReceiver);
        vm.stopBroadcast();
    }
}
