// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Test } from "forge-std/Test.sol";

import { CasterFactory } from "@src/CasterFactory.sol";
import { CasterTypes } from "@src/utils/CasterTypes.sol";

abstract contract GlobalHelper is Test {
    CasterFactory public factory;

    address public owner;
    address public user1;
    address public user2;
    address public user3;

    bytes32 public merkleRoot;
    bytes32[] public user1Proof;
    bytes32[] public user2Proof;
    bytes32[] public user3Proof;

    function setUp() public {
        // Since these are anvil accounts, they will be prefunded with 10,000 ETH each
        owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Anvil account 0
        user1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Anvil account 1
        user2 = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC; // Anvil account 2
        user3 = 0x90F79bf6EB2c4f870365E785982E1f101E93b906; // Anvil account 3

        vm.prank(owner);
        factory = new CasterFactory(owner);

        merkleRoot = 0xdf44750511aab2f7b70d8477ca3b5cd5acaa9fc0035692122f63c742012a176a;

        user1Proof.push(0x457aa17fe0228467c8ff03c94ef937caf43d83d6102043300dc6a2e9a13a7006);
        user1Proof.push(0xb603ca691aa0d0ecd0b23afbf705f86ee2309d5b7538017d6355987c2ea8ca9c);

        user2Proof.push(0x418b8260135dc95e801fbf75c0f9c0ba3a2ca240486494f1c953920249db2c2a);
        user2Proof.push(0xb603ca691aa0d0ecd0b23afbf705f86ee2309d5b7538017d6355987c2ea8ca9c);

        user3Proof.push(0x88bb2f4fef303737bc744b72da433181073d8e442f7eb9c0ee57076127733094);
    }

    function _getSingleOptionVotingcampaignParams()
        internal
        pure
        returns (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        )
    {
        name = "DeFi prospects";
        description = "Speculate on the future of DeFi";
        optionName = "Defi will cross the 1 trillion dollar mark";
        optionDescription = "Vote for or against the statement";
        duration = 2 days;
    }

    function _getMultipleOptionVotingCampaignParams()
        internal
        pure
        returns (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        )
    {
        name = "Fruity choice";
        description = "Choose your favourite fruit";
        option1 = new string[](2);
        option2 = new string[](2);
        option1[0] = "Apples";
        option1[1] = "Vote for apples";
        option2[0] = "Oranges";
        option2[1] = "Vote for oranges";
        duration = 2 days;
    }

    function _deploySingleOptionVotingCampaign(
        string memory _name,
        string memory _description,
        string memory _optionName,
        string memory _optionDescription,
        bytes32 _merkleRoot,
        uint256 _duration
    )
        internal
        returns (address votingCampaign)
    {
        CasterTypes.OptionDetails[] memory optionDetails = new CasterTypes.OptionDetails[](1);
        optionDetails[0] = CasterTypes.OptionDetails({ name: _optionName, description: _optionDescription });
        CasterTypes.CreateCampaign memory params = CasterTypes.CreateCampaign({
            name: _name,
            description: _description,
            campaignType: CasterTypes.CampaignType.SingleOption,
            options: optionDetails,
            merkleRoot: _merkleRoot,
            duration: _duration
        });

        vm.prank(owner);
        votingCampaign = factory.createVotingCampaign{ value: factory.getFee() }(params);
    }

    function _deployMultipleOptionCampaign(
        string memory _name,
        string memory _description,
        string[] memory _option1,
        string[] memory _option2,
        bytes32 _merkleRoot,
        uint256 _duration
    )
        internal
        returns (address votingCampaign)
    {
        CasterTypes.OptionDetails[] memory optionDetails = new CasterTypes.OptionDetails[](2);
        optionDetails[0] = CasterTypes.OptionDetails({ name: _option1[0], description: _option1[1] });
        optionDetails[1] = CasterTypes.OptionDetails({ name: _option2[0], description: _option2[1] });
        CasterTypes.CreateCampaign memory params = CasterTypes.CreateCampaign({
            name: _name,
            description: _description,
            campaignType: CasterTypes.CampaignType.MultipleOption,
            options: optionDetails,
            merkleRoot: _merkleRoot,
            duration: _duration
        });

        vm.prank(owner);
        votingCampaign = factory.createVotingCampaign{ value: factory.getFee() }(params);
    }
}
