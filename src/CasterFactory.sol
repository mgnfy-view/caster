// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { ICasterFactory } from "./interfaces/ICasterFactory.sol";

import { CasterCampaign } from "./CasterCampaign.sol";
import { CasterTypes } from "./utils/CasterTypes.sol";

contract CasterFactory is ICasterFactory {
    mapping(address user => uint256 nonce) private s_nonces;
    mapping(bytes32 hash => address campaign) private s_hashToCampaign;

    uint256 private constant MAX_DURATION = 365 days;

    address[] private s_allCampaigns;

    event VotingCampaignCreated(
        address indexed creator,
        CasterTypes.CreateCampaign campaignParams,
        address indexed campaignAddress,
        bytes32 indexed merkleRoot,
        bytes32 campaignHash
    );

    error CasterFactory__InvalidVotingCampaignParams();

    function createVotingCampaign(CasterTypes.CreateCampaign memory _campaignParams)
        external
        returns (address votingCampaign)
    {
        if (
            (
                _campaignParams.campaignType == CasterTypes.CampaignType.SingleOption
                    && _campaignParams.options.length == 1
            )
                || (
                    _campaignParams.campaignType == CasterTypes.CampaignType.MultipleOption
                        && _campaignParams.options.length > 1
                )
        ) {
            if (_campaignParams.duration > MAX_DURATION) {
                revert CasterFactory__InvalidVotingCampaignParams();
            }
            votingCampaign = address(new CasterCampaign(_campaignParams));
        } else {
            revert CasterFactory__InvalidVotingCampaignParams();
        }

        bytes32 campaignHash =
            keccak256(abi.encode(msg.sender, _campaignParams.name, _campaignParams.merkleRoot, s_nonces[msg.sender]));
        s_hashToCampaign[campaignHash] = votingCampaign;
        s_nonces[msg.sender] = s_nonces[msg.sender] + 1;
        s_allCampaigns.push(votingCampaign);

        emit VotingCampaignCreated(
            msg.sender, _campaignParams, votingCampaign, _campaignParams.merkleRoot, campaignHash
        );
    }
}
