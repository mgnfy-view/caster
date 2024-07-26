// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { GlobalHelper } from "../utils/GlobalHelper.sol";

import { ICasterCampaign } from "@src/interfaces/ICasterCampaign.sol";
import { ICasterNft } from "@src/interfaces/ICasterNft.sol";

import { CasterTypes } from "@src/utils/CasterTypes.sol";

contract CasterProtocolTest is GlobalHelper {
    function testInitialization() public view {
        assertEq(factory.owner(), owner);
        assertEq(factory.getFeeReceiver(), owner);
    }

    function testDeploySingleOptionVotingCampaign() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);
        CasterTypes.SingleOption memory singleOption = ICasterCampaign(votingCampaign).getSingleOption();

        assertEq(ICasterCampaign(votingCampaign).getCampaignName(), name);
        assertEq(ICasterCampaign(votingCampaign).getCampaignDescription(), description);
        assertEq(singleOption.details.name, optionName);
        assertEq(singleOption.details.description, optionDescription);
        assertEq(uint8(ICasterCampaign(votingCampaign).getCampaignType()), uint8(CasterTypes.CampaignType.SingleOption));
        assertEq(ICasterCampaign(votingCampaign).getMerkleRoot(), merkleRoot);
        assertEq(ICasterCampaign(votingCampaign).getLastTimestamp(), block.timestamp);
        assertEq(ICasterCampaign(votingCampaign).getCampaignDuration(), duration);
        assert(ICasterCampaign(votingCampaign).getCasterNft() != address(0));
    }

    function testDeployMultipleOptonVotingCampaign() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);
        CasterTypes.MultipleOption[] memory multipleOption = ICasterCampaign(votingCampaign).getMultipleOptions();

        assertEq(ICasterCampaign(votingCampaign).getCampaignName(), name);
        assertEq(ICasterCampaign(votingCampaign).getCampaignDescription(), description);
        assertEq(multipleOption[0].details.name, option1[0]);
        assertEq(multipleOption[1].details.name, option2[0]);
        assertEq(multipleOption[0].details.description, option1[1]);
        assertEq(multipleOption[1].details.description, option2[1]);
        assertEq(
            uint8(ICasterCampaign(votingCampaign).getCampaignType()), uint8(CasterTypes.CampaignType.MultipleOption)
        );
        assertEq(ICasterCampaign(votingCampaign).getMerkleRoot(), merkleRoot);
        assertEq(ICasterCampaign(votingCampaign).getLastTimestamp(), block.timestamp);
        assertEq(ICasterCampaign(votingCampaign).getCampaignDuration(), duration);
        assert(ICasterCampaign(votingCampaign).getCasterNft() != address(0));
    }

    function testMintCampaignIdForSingleOptionVotingCampaign() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        vm.prank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(IERC721(casterNft).balanceOf(user1), 1);
        assertEq(ICasterNft(casterNft).getUserId(user1), 1);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 2);
    }

    function testMintCampaignIdForMultipleOptionVotingCampaign() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        vm.prank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(IERC721(casterNft).balanceOf(user1), 1);
        assertEq(ICasterNft(casterNft).getUserId(user1), 1);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 2);
    }

    function testSingleOptionVotingCampaignVoteDelegation() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        vm.prank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        address user4 = makeAddr("user4");
        vm.prank(user1);
        ICasterCampaign(votingCampaign).delegateTo(user4, 2);

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), 2);
    }

    function testMultipleOptionVotingCampaignVoteDelegation() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        vm.prank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        address user4 = makeAddr("user4");
        vm.prank(user1);
        ICasterCampaign(votingCampaign).delegateTo(user4, 2);

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), 2);
    }

    function testSingleOptionVotingCampaignCastVote() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(false, 2);
        vm.stopPrank();
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterCampaign(votingCampaign).getSingleOption().votesFor, 2);
        assertEq(ICasterCampaign(votingCampaign).getSingleOption().votesAgainst, 0);
    }

    function testMultipleOptionVotingCampaignCastVote() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(0, 2);
        vm.stopPrank();
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterCampaign(votingCampaign).getMultipleOptions()[0].votesFor, 2);
    }

    function testGetSingleOptionVotingCampaignWinner() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(false, 2);
        vm.stopPrank();

        vm.startPrank(user2);
        ICasterCampaign(votingCampaign).mintCampaignId(1, user2Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(false, 1);
        vm.stopPrank();
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        vm.warp(2 days + 1);

        assertEq(
            uint8(ICasterCampaign(votingCampaign).getResultSingleOption()), uint8(CasterTypes.SingleOptionResult.For)
        );
    }

    function testGetMultipleOptionVotingCampaignWinner() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(0, 2);
        vm.stopPrank();

        vm.startPrank(user2);
        ICasterCampaign(votingCampaign).mintCampaignId(1, user2Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(0, 1);
        vm.stopPrank();
        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        vm.warp(2 days + 1);

        assertEq(ICasterCampaign(votingCampaign).getResultMultipleOption(), 0);
    }
}
