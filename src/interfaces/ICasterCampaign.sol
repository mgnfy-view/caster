// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { CasterTypes } from "@src/utils/CasterTypes.sol";

interface ICasterCampaign {
    function mintCampaignId(
        uint256 _votingPower,
        bytes32[] memory _merkleProof,
        string memory _uri
    )
        external
        returns (uint256 id);

    function delegateTo(address _user, uint256 _votes) external;

    function batchDelegate(address[] memory _users, uint256[] memory _votes) external;

    function voteSingleOption(bool _isAgainst, uint256 _votes) external;

    function voteMultipleOption(uint256 _index, uint256 _votes) external;

    function getResultSingleOption() external view returns (CasterTypes.SingleOptionResult result);

    function getResultMultipleOption() external view returns (uint256 index);

    function getCampaignName() external view returns (string memory name);

    function getCampaignDescription() external view returns (string memory description);

    function getCampaignType() external view returns (CasterTypes.CampaignType campaignType);

    function getSingleOption() external view returns (CasterTypes.SingleOption memory singleOption);

    function getMultipleOptions() external view returns (CasterTypes.MultipleOption[] memory multipleOptions);

    function getMerkleRoot() external view returns (bytes32 merkleRoot);

    function getLastTimestamp() external view returns (uint256 lastTimestamp);

    function getCampaignDuration() external view returns (uint256 duration);

    function getCasterNft() external view returns (address casterNft);
}
