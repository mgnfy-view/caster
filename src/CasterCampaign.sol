// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { ICasterCampaign } from "./interfaces/ICasterCampaign.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import { ICasterNft } from "./interfaces/ICasterNft.sol";

import { CasterNft } from "./CasterNft.sol";
import { CasterTypes } from "./utils/CasterTypes.sol";

/**
 * @title CasterCampaign.
 * @author mgnfy-view.
 * @notice Caster voting campaigns are deployed by the Caster factory and allow eligible
 * users to mint a unique voting id (Nft), delegate their votes, and vote for or against options.
 *
 */
contract CasterCampaign is ICasterCampaign {
    string private s_name;
    string private s_description;
    CasterTypes.CampaignType private immutable i_campaignType;
    CasterTypes.SingleOption private s_singleOption;
    CasterTypes.MultipleOption[] private s_multipleOptions;
    bytes32 private immutable i_merkleRoot;

    uint256 private immutable i_lastTimestamp;
    uint256 private immutable i_duration;

    address private immutable i_casterNft;

    event Initialized(CasterTypes.CreateCampaign indexed camaignParams, address indexed casterNft);
    event VoterRegistered(address indexed user, uint256 indexed votingPower, uint256 indexed id, bytes32[] merkleProof);
    event VotingPowerDelegated(address indexed by, address indexed to, uint256 indexed votes);
    event VotingPowerBatchDelegated(address indexed by, address[] indexed users, uint256[] indexed votes);
    event VotedSingleOption(address indexed user, bool indexed isAgainst, uint256 indexed votes);
    event VotedMultipleOption(address indexed user, uint256 indexed index, uint256 votes);

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

    modifier beforeCampaignEnd() {
        if (block.timestamp > i_lastTimestamp + i_duration) revert CasterCampaign__VotingCampaignEnded();
        _;
    }

    modifier afterCampaignEnd() {
        if (block.timestamp < i_lastTimestamp + i_duration) revert CasterCampaign__VotingCampaignInProgress();
        _;
    }

    constructor(CasterTypes.CreateCampaign memory _campaignParams) {
        s_name = _campaignParams.name;
        s_description = _campaignParams.description;
        i_campaignType = _campaignParams.campaignType;

        if (_campaignParams.campaignType == CasterTypes.CampaignType.SingleOption) {
            s_singleOption = CasterTypes.SingleOption({
                details: CasterTypes.OptionDetails({
                    name: _campaignParams.options[0].name,
                    description: _campaignParams.options[0].description
                }),
                votesFor: 0,
                votesAgainst: 0
            });
        } else {
            uint256 optionLength = _campaignParams.options.length;
            for (uint256 count; count < optionLength; ++count) {
                s_multipleOptions.push(
                    CasterTypes.MultipleOption({
                        details: CasterTypes.OptionDetails({
                            name: _campaignParams.options[count].name,
                            description: _campaignParams.options[count].description
                        }),
                        votesFor: 0
                    })
                );
            }
        }

        i_merkleRoot = _campaignParams.merkleRoot;

        i_lastTimestamp = block.timestamp;
        i_duration = _campaignParams.duration;

        string memory nftName = "Caster Voting Id";
        string memory nftSymbol = "CSTR-NFT";
        i_casterNft = address(new CasterNft(nftName, nftSymbol));

        emit Initialized(_campaignParams, i_casterNft);
    }

    /**
     * @notice Mints a unique voting id (Nft) to an eligible voter (if the user can prove themselves
     * to be part of the merkle root supplied by the campaign creator).
     * @param _votingPower The number of votes the user has.
     * @param _merkleProof The proof required to prove that the user is a part of the merkle tree.
     * @param _uri Preferably, a custom IPFS URI which allows users to set their details for the campaign.
     * @return id The unique voting id (Nft) minted.
     */
    function mintCampaignId(
        uint256 _votingPower,
        bytes32[] memory _merkleProof,
        string memory _uri
    )
        external
        beforeCampaignEnd
        returns (uint256 id)
    {
        if (IERC721(i_casterNft).balanceOf(msg.sender) > 0) {
            revert CasterCampaign__VotingIdAlreadyMinted();
        }

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, _votingPower))));
        if (!MerkleProof.verify(_merkleProof, i_merkleRoot, leaf)) {
            revert CasterCampaign__InvalidProof();
        }
        id = ICasterNft(i_casterNft).mint(msg.sender, _votingPower, _uri);

        emit VoterRegistered(msg.sender, _votingPower, id, _merkleProof);
    }

    /**
     * @notice Allows any eligible voter to delegate their votes to a single user.
     * @param _user The user to delegate votes to.
     * @param _votes The number of votes to delegate.
     */
    function delegateTo(address _user, uint256 _votes) external beforeCampaignEnd {
        if (IERC721(i_casterNft).balanceOf(msg.sender) == 0) revert CasterCampaign__NoChainedDelegationAllowed();
        ICasterNft(i_casterNft).decreaseVotingPower(msg.sender, _votes);
        ICasterNft(i_casterNft).increaseVotingPower(_user, _votes);

        emit VotingPowerDelegated(msg.sender, _user, _votes);
    }

    /**
     * @notice Allows any eligible voter to delegate their votes to multiple users.
     * @param _users The user addresses.
     * @param _votes The amount of votes to delegate to different users.
     */
    function batchDelegate(address[] memory _users, uint256[] memory _votes) external beforeCampaignEnd {
        uint256 usersLength = _users.length;
        uint256 votesLength = _votes.length;

        if (IERC721(i_casterNft).balanceOf(msg.sender) == 0) revert CasterCampaign__NoChainedDelegationAllowed();
        if (usersLength != votesLength) revert CasterCampaign__ArraySizesDonotMatch();

        uint256 totalVotes;

        for (uint256 count; count < usersLength; ++count) {
            totalVotes = totalVotes + _votes[count];
            ICasterNft(i_casterNft).increaseVotingPower(_users[count], _votes[count]);
        }

        ICasterNft(i_casterNft).decreaseVotingPower(msg.sender, totalVotes);

        emit VotingPowerBatchDelegated(msg.sender, _users, _votes);
    }

    /**
     * @notice Allows voters with voting powers (received through the Nft or delegation) to vote in a
     * single option campaign.
     * @param _isAgainst True if against the option, false otherwise.
     * @param _votes The number of votes to use.
     */
    function voteSingleOption(bool _isAgainst, uint256 _votes) external beforeCampaignEnd {
        if (i_campaignType == CasterTypes.CampaignType.MultipleOption) {
            revert CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType.MultipleOption);
        }

        if (_isAgainst) {
            s_singleOption.votesAgainst = s_singleOption.votesAgainst + _votes;
        } else {
            s_singleOption.votesFor = s_singleOption.votesFor + _votes;
        }

        ICasterNft(i_casterNft).decreaseVotingPower(msg.sender, _votes);

        emit VotedSingleOption(msg.sender, _isAgainst, _votes);
    }

    /**
     * @notice Allows voters with voting powers (received through the Nft or delegation) to vote in a
     * multiple option campaign.
     * @param _index The option to vote for.
     * @param _votes The number of votes to use.
     */
    function voteMultipleOption(uint256 _index, uint256 _votes) external beforeCampaignEnd {
        if (i_campaignType == CasterTypes.CampaignType.SingleOption) {
            revert CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType.SingleOption);
        }
        if (_index >= s_multipleOptions.length) revert CasterCampaign__InvalidOption();

        s_multipleOptions[_index].votesFor = s_multipleOptions[_index].votesFor + _votes;

        ICasterNft(i_casterNft).decreaseVotingPower(msg.sender, _votes);

        emit VotedMultipleOption(msg.sender, _index, _votes);
    }

    /**
     * @notice Gets the result of a single option voting campaign.
     * @return result The result -- For (statement agreed with), Against (statement disagreed with), or Tie.
     */
    function getResultSingleOption() external view afterCampaignEnd returns (CasterTypes.SingleOptionResult result) {
        if (i_campaignType == CasterTypes.CampaignType.MultipleOption) {
            revert CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType.MultipleOption);
        }

        CasterTypes.SingleOption memory singleOption = s_singleOption;

        if (singleOption.votesFor > singleOption.votesAgainst) result = CasterTypes.SingleOptionResult.For;
        else if (singleOption.votesFor > singleOption.votesAgainst) result = CasterTypes.SingleOptionResult.Against;
        else result = CasterTypes.SingleOptionResult.Tie;
    }

    /**
     * @notice Gets the result of a single option voting campaign.
     * @return index The index of the winning option. type(uint256).max in case of a tie.
     */
    function getResultMultipleOption() external view afterCampaignEnd returns (uint256 index) {
        if (i_campaignType == CasterTypes.CampaignType.SingleOption) {
            revert CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType.SingleOption);
        }

        CasterTypes.MultipleOption[] memory multipleOptions = s_multipleOptions;
        uint256 length = multipleOptions.length;
        uint256 maxVotes = multipleOptions[0].votesFor;
        index = 0;

        for (uint256 count = 1; count < length; ++count) {
            if (maxVotes < multipleOptions[count].votesFor) {
                maxVotes = multipleOptions[count].votesFor;
                index = count;
            }
        }

        for (uint256 count = 1; count < length; ++count) {
            if (maxVotes == multipleOptions[count].votesFor && index != count) {
                maxVotes = type(uint256).max;
                index = type(uint256).max;
            }
        }
    }

    /**
     * @notice Gets the campaign's name.
     * @return name A string name.
     */
    function getCampaignName() external view returns (string memory name) {
        name = s_name;
    }

    /**
     * @notice Gets the campaign's description.
     * @return description A string description.
     */
    function getCampaignDescription() external view returns (string memory description) {
        description = s_description;
    }

    /**
     * @notice Gets the campaign type (single option or multiple option).
     * @return campaignType 0 for single option and 1 for multiple option campaign.
     */
    function getCampaignType() external view returns (CasterTypes.CampaignType campaignType) {
        campaignType = i_campaignType;
    }

    /**
     * @notice Gets the single option details.
     * @return singleOption The SingleOption struct.
     */
    function getSingleOption() external view returns (CasterTypes.SingleOption memory singleOption) {
        singleOption = s_singleOption;
    }

    /**
     * @notice Gets the multiple options available to vote for in a multiple option campaign.
     * @return multipleOptions An array of MultipleOption structs.
     */
    function getMultipleOptions() external view returns (CasterTypes.MultipleOption[] memory multipleOptions) {
        multipleOptions = s_multipleOptions;
    }

    /**
     * @notice The merkle root for a campaign. Used to verify/validate eligible users.
     * @return merkleRoot A bytes32 merkle root.
     */
    function getMerkleRoot() external view returns (bytes32 merkleRoot) {
        merkleRoot = i_merkleRoot;
    }

    /**
     * @notice The timestamp when the campaign was deployed.
     * @return lastTimestamp The UNIX timestamp.
     */
    function getLastTimestamp() external view returns (uint256 lastTimestamp) {
        lastTimestamp = i_lastTimestamp;
    }

    /**
     * @notice Gets the duration for which the campaign will run.
     * @return duration The campaign duration.
     */
    function getCampaignDuration() external view returns (uint256 duration) {
        duration = i_duration;
    }

    /**
     * @notice Gets the Caster Nft associated with this campaign.
     * @return casterNft The address of the Caster Nft.
     */
    function getCasterNft() external view returns (address casterNft) {
        casterNft = i_casterNft;
    }
}
