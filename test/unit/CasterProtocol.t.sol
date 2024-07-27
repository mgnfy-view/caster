// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { console } from "forge-std/console.sol";

import { GlobalHelper } from "../utils/GlobalHelper.sol";

import { ICasterCampaign } from "@src/interfaces/ICasterCampaign.sol";
import { ICasterNft } from "@src/interfaces/ICasterNft.sol";

import { CasterTypes } from "@src/utils/CasterTypes.sol";

contract CasterProtocolTest is GlobalHelper {
    function testInitialization() public view {
        uint256 maxDuration = 365 days;
        uint256 fee = 0.001 ether;

        assertEq(factory.getCampaignMaxDuration(), maxDuration);
        assertEq(factory.getAllCampaigns().length, 0);
        assertEq(factory.getFeeReceiver(), owner);
        assertEq(factory.getFee(), fee);
        assertEq(factory.owner(), owner);
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
        bytes32 hash = keccak256(abi.encode(owner, name, merkleRoot, factory.getNonceForUser(owner) - uint256(1)));

        assertEq(factory.getCampaignFromHash(hash), votingCampaign);
        assertEq(factory.getAllCampaigns()[0], votingCampaign);
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
        bytes32 hash = keccak256(abi.encode(owner, name, merkleRoot, factory.getNonceForUser(owner) - uint256(1)));

        assertEq(factory.getCampaignFromHash(hash), votingCampaign);
        assertEq(factory.getAllCampaigns()[0], votingCampaign);
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

        uint256 userVotingPower = 2;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(userVotingPower, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 userBalance = 1;
        uint256 userId = 1;

        assertEq(IERC721(casterNft).balanceOf(user1), userBalance);
        assertEq(ICasterNft(casterNft).getUserId(user1), userId);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), userVotingPower);
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

        uint256 userVotingPower = 2;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(userVotingPower, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 userBalance = 1;
        uint256 userId = 1;

        assertEq(IERC721(casterNft).balanceOf(user1), userBalance);
        assertEq(ICasterNft(casterNft).getUserId(user1), userId);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), userVotingPower);
    }

    function testMintCampaignIdForSingleOptionVotingCampaignFailsWhenUserNotAPartOfTree() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        uint256 votingPower = 2;

        vm.startPrank(owner);
        vm.expectRevert(CasterCampaign__InvalidProof.selector);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        vm.stopPrank();
    }

    function testMintCampaignIdForMultipleOptionVotingCampaignFailsWhenUserNotAPartOfTree() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        uint256 votingPower = 2;

        vm.startPrank(owner);
        vm.expectRevert(CasterCampaign__InvalidProof.selector);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        vm.stopPrank();
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

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(2, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 votesToDelegate = 2;

        address user4 = makeAddr("user4");
        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).delegateTo(user4, votesToDelegate);
        vm.stopPrank();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), votesToDelegate);
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

        uint256 votingPower = 2;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 votesToDelegate = 2;

        address user4 = makeAddr("user4");
        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).delegateTo(user4, votesToDelegate);
        vm.stopPrank();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), votesToDelegate);
    }

    function testSingleOptionVotingCampaignBatchVoteDelegation() public {
        (
            string memory name,
            string memory description,
            string memory optionName,
            string memory optionDescription,
            uint256 duration
        ) = _getSingleOptionVotingcampaignParams();

        address votingCampaign =
            _deploySingleOptionVotingCampaign(name, description, optionName, optionDescription, merkleRoot, duration);

        uint256 votingPower = 2;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 votesToDelegatePerUser = 1;

        address user4 = makeAddr("user4");
        address user5 = makeAddr("user5");
        address[] memory users = new address[](2);
        users[0] = user4;
        users[1] = user5;
        uint256[] memory votes = new uint256[](2);
        votes[0] = votesToDelegatePerUser;
        votes[1] = votesToDelegatePerUser;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).batchDelegate(users, votes);
        vm.stopPrank();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), votesToDelegatePerUser);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user5), votesToDelegatePerUser);
    }

    function testMultipleOptionVotingCampaignBatchVoteDelegation() public {
        (
            string memory name,
            string memory description,
            string[] memory option1,
            string[] memory option2,
            uint256 duration
        ) = _getMultipleOptionVotingCampaignParams();

        address votingCampaign =
            _deployMultipleOptionCampaign(name, description, option1, option2, merkleRoot, duration);

        uint256 votingPower = 2;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();
        uint256 votesToDelegatePerUser = 1;

        address user4 = makeAddr("user4");
        address user5 = makeAddr("user5");
        address[] memory users = new address[](2);
        users[0] = user4;
        users[1] = user5;
        uint256[] memory votes = new uint256[](2);
        votes[0] = votesToDelegatePerUser;
        votes[1] = votesToDelegatePerUser;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).batchDelegate(users, votes);
        vm.stopPrank();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user4), votesToDelegatePerUser);
        assertEq(ICasterNft(casterNft).getUserVotingPower(user5), votesToDelegatePerUser);
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

        uint256 votingPower = 2;
        uint256 votesToCast = votingPower;
        bool isAgainst = false;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(isAgainst, votesToCast);
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterCampaign(votingCampaign).getSingleOption().votesFor, votesToCast);
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

        uint256 votingPower = 2;
        uint256 votesToCast = votingPower;
        uint256 option = 0;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(votingPower, user1Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(option, votesToCast);
        vm.stopPrank();

        address casterNft = ICasterCampaign(votingCampaign).getCasterNft();

        assertEq(ICasterNft(casterNft).getUserVotingPower(user1), 0);
        assertEq(ICasterCampaign(votingCampaign).getMultipleOptions()[0].votesFor, votesToCast);
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

        uint256 user1VotingPower = 2;
        uint256 user1VotesToCast = user1VotingPower;
        bool user1IsAgainst = false;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(user1VotingPower, user1Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(user1IsAgainst, user1VotesToCast);
        vm.stopPrank();

        uint256 user2VotingPower = 1;
        uint256 user2VotesToCast = user2VotingPower;
        bool user2IsAgainst = false;

        vm.startPrank(user2);
        ICasterCampaign(votingCampaign).mintCampaignId(user2VotingPower, user2Proof, "");
        ICasterCampaign(votingCampaign).voteSingleOption(user2IsAgainst, user2VotesToCast);
        vm.stopPrank();

        vm.warp(duration + 1);

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

        uint256 user1VotingPower = 2;
        uint256 user1VotesToCast = user1VotingPower;
        uint256 user1Option = 0;

        vm.startPrank(user1);
        ICasterCampaign(votingCampaign).mintCampaignId(user1VotingPower, user1Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(user1Option, user1VotesToCast);
        vm.stopPrank();

        uint256 user2VotingPower = 1;
        uint256 user2VotesToCast = user2VotingPower;
        uint256 user2Option = 0;

        vm.startPrank(user2);
        ICasterCampaign(votingCampaign).mintCampaignId(user2VotingPower, user2Proof, "");
        ICasterCampaign(votingCampaign).voteMultipleOption(user2Option, user2VotesToCast);
        vm.stopPrank();

        vm.warp(duration + 1);

        assertEq(ICasterCampaign(votingCampaign).getResultMultipleOption(), 0);
    }
}
