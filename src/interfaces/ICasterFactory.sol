// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { CasterTypes } from "@src/utils/CasterTypes.sol";

interface ICasterFactory {
    function createVotingCampaign(CasterTypes.CreateCampaign memory _campaignParams)
        external
        payable
        returns (address votingCampaign);

    function changeFeeReceiver(address _newFeeReceiver) external;

    function getNonceForUser(address _user) external view returns (uint256 nonce);

    function getCampaignFromHash(bytes32 _hash) external view returns (address campaign);

    function getCampaignMaxDuration() external pure returns (uint256 maxDuration);

    function getAllCampaigns() external view returns (address[] memory allCampaigns);

    function getFeeReceiver() external view returns (address feeReceiver);

    function getFee() external pure returns (uint256 fee);
}
