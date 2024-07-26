// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ICasterFactory } from "./interfaces/ICasterFactory.sol";

import { CasterCampaign } from "./CasterCampaign.sol";
import { CasterTypes } from "./utils/CasterTypes.sol";

contract CasterFactory is Ownable, ICasterFactory {
    mapping(address user => uint256 nonce) private s_nonces;
    mapping(bytes32 hash => address campaign) private s_hashToCampaign;

    uint256 private constant MAX_DURATION = 365 days;

    address[] private s_allCampaigns;

    address private s_feeReceiver;
    uint256 private constant FEE = 0.001 ether;

    event VotingCampaignCreated(
        address indexed creator,
        CasterTypes.CreateCampaign campaignParams,
        address indexed campaignAddress,
        bytes32 indexed merkleRoot,
        bytes32 campaignHash
    );

    event FeeReceiverChanged(address indexed feeReceiver);

    error CasterFactory__InsufficientFeeSupplied();
    error CasterFactory__InvalidVotingCampaignParams();
    error CasterFactory__TransferFailed();

    constructor(address _feeReceiver) Ownable(msg.sender) {
        s_feeReceiver = _feeReceiver;
    }

    function createVotingCampaign(CasterTypes.CreateCampaign memory _campaignParams)
        external
        payable
        returns (address votingCampaign)
    {
        if (msg.value < FEE) revert CasterFactory__InsufficientFeeSupplied();
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

        (bool success,) = payable(s_feeReceiver).call{ value: msg.value }("");
        if (!success) revert CasterFactory__TransferFailed();

        emit VotingCampaignCreated(
            msg.sender, _campaignParams, votingCampaign, _campaignParams.merkleRoot, campaignHash
        );
    }

    function changeFeeReceiver(address _newFeeReceiver) external onlyOwner {
        s_feeReceiver = _newFeeReceiver;

        emit FeeReceiverChanged(_newFeeReceiver);
    }

    function getNonceForUser(address _user) external view returns (uint256 nonce) {
        nonce = s_nonces[_user];
    }

    function getCampaignFromHash(bytes32 _hash) external view returns (address campaign) {
        campaign = s_hashToCampaign[_hash];
    }

    function getCampaignMaxDuration() external pure returns (uint256 maxDuration) {
        maxDuration = MAX_DURATION;
    }

    function getAllCampaigns() external view returns (address[] memory allCampaigns) {
        allCampaigns = s_allCampaigns;
    }
}
