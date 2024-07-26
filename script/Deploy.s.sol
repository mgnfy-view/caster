// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";

import { CasterFactory } from "@src/CasterFactory.sol";

contract Deploy is Script {
    address public s_feeReceiver;
    CasterFactory public s_factory;

    uint256 constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 constant ANVIL_CHAIN_ID = 31337;

    error Deploy__InvalidChainId();

    function run() public {
        s_feeReceiver = address(0x1); // Set the correct fee receiver here

        vm.startBroadcast();
        s_factory = new CasterFactory(s_feeReceiver);
        vm.stopBroadcast();
    }

    function getFeeReceiver() public view returns (address feeReceiver) {
        // Use a custom EOA address for Sepolia testnet
        if (block.chainid == SEPOLIA_CHAIN_ID) feeReceiver = 0xE5261f469bAc513C0a0575A3b686847F48Bc6687;
        // For anvil, the fee receiver is the default account
        else if (block.chainid == ANVIL_CHAIN_ID) feeReceiver = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        else revert Deploy__InvalidChainId();
    }
}
