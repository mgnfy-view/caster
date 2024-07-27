// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { CasterTypes } from "@src/utils/CasterTypes.sol";

abstract contract EventsAndErrors {
    event FeeReceiverChanged(address indexed feeReceiver);
    event Initialized(CasterTypes.CreateCampaign indexed camaignParams, address indexed casterNft);
    event VoterRegistered(address indexed user, uint256 indexed votingPower, uint256 indexed id, bytes32[] merkleProof);
    event VotingPowerDelegated(address indexed by, address indexed to, uint256 indexed votes);
    event VotingPowerBatchDelegated(address indexed by, address[] indexed users, uint256[] indexed votes);
    event VotedSingleOption(address indexed user, bool indexed isAgainst, uint256 indexed votes);
    event VotedMultipleOption(address indexed user, uint256 indexed index, uint256 votes);
    event VotingPowerIncreased(address indexed user, uint256 indexed amount);
    event VotingPowerDecreased(address indexed user, uint256 indexed amount);

    error CasterFactory__InsufficientFeeSupplied();
    error CasterFactory__InvalidVotingCampaignParams();
    error CasterFactory__TransferFailed();
    error CasterCampaign__VotingCampaignEnded();
    error CasterCampaign__VotingCampaignInProgress();
    error CasterCampaign__VotingIdAlreadyMinted();
    error CasterCampaign__InvalidProof();
    error CasterCampaign__NoChainedDelegationAllowed();
    error CasterCampaign__ArraySizesDonotMatch();
    error CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType campaignType);
    error CasterCampaign__NotRegistered();
    error CasterCampaign__NotEnoughVotes();
    error CasterCampaign__InvalidOption();
    error CasterNft__VotingIdAlreadyMinted();
}
