// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ICasterFactory } from "./interfaces/ICasterFactory.sol";

import { CasterCampaign } from "./CasterCampaign.sol";
import { CasterTypes } from "./utils/CasterTypes.sol";

/**
 * @title CasterFactory.
 * @author mgnfy-view.
 * @notice This contract is the entry point to the Caster protocol. Any user can create voting
 * campaigns in a permissionless manner.
 */
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

    /**
     * @notice Allows anyone to deploy a new voting campaign by paying a small fee.
     * @param _campaignParams The parameters for the campaign creation.
     * @return votingCampaign The address of the deployed voting campaign.
     */
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

    /**
     * @notice Allows the owner to change the fee receiver address.
     * @param _newFeeReceiver The new fee receiver's address.
     */
    function changeFeeReceiver(address _newFeeReceiver) external onlyOwner {
        s_feeReceiver = _newFeeReceiver;

        emit FeeReceiverChanged(_newFeeReceiver);
    }

    /**
     * @notice Gets the nonce of the user.
     * @param _user The user's address.
     * @return nonce The nonce value.
     */
    function getNonceForUser(address _user) external view returns (uint256 nonce) {
        nonce = s_nonces[_user];
    }

    /**
     * @notice Gets the address of the deployed campaign from the supplied hash.
     * @param _hash The hash of the campaign generated using keccak256(abi.encode(owner, campaignName, merkleRoot, nonce)).
     * @return campaign The campaign's address.
     */
    function getCampaignFromHash(bytes32 _hash) external view returns (address campaign) {
        campaign = s_hashToCampaign[_hash];
    }

    /**
     * @notice Gets the max duration any campaign can run for.
     * @return maxDuration The max duration.
     */
    function getCampaignMaxDuration() external pure returns (uint256 maxDuration) {
        maxDuration = MAX_DURATION;
    }

    /**
     * @notice Gets addresses of all campaigns deployed so far. Useful for UI development purposes.
     * @return allCampaigns Addresses of all campaigns deployed so far.
     */
    function getAllCampaigns() external view returns (address[] memory allCampaigns) {
        allCampaigns = s_allCampaigns;
    }

    /**
     * @notice Gets the fee receiver's address.
     * @return feeReceiver The fee receiver's address.
     */
    function getFeeReceiver() external view returns (address feeReceiver) {
        feeReceiver = s_feeReceiver;
    }

    /**
     * @notice Gets the fee to pay in native currency while deploying a campaign.
     * @return fee The fee value.
     */
    function getFee() external pure returns (uint256 fee) {
        fee = FEE;
    }
}
