# CasterCampaign
[Git Source](https://github.com/mgnfy-view/caster/blob/8657e2d8bdc226333eb8f21b2a1461cea0ac8fff/src/CasterCampaign.sol)

**Inherits:**
[ICasterCampaign](/src/interfaces/ICasterCampaign.sol/interface.ICasterCampaign.md)

**Author:**
mgnfy-view.

Caster voting campaigns are deployed by the Caster factory and allow eligible
users to mint a unique voting id (Nft), delegate their votes, and vote for or against options.


## State Variables
### s_name

```solidity
string private s_name;
```


### s_description

```solidity
string private s_description;
```


### i_campaignType

```solidity
CasterTypes.CampaignType private immutable i_campaignType;
```


### s_singleOption

```solidity
CasterTypes.SingleOption private s_singleOption;
```


### s_multipleOptions

```solidity
CasterTypes.MultipleOption[] private s_multipleOptions;
```


### i_merkleRoot

```solidity
bytes32 private immutable i_merkleRoot;
```


### i_lastTimestamp

```solidity
uint256 private immutable i_lastTimestamp;
```


### i_duration

```solidity
uint256 private immutable i_duration;
```


### i_casterNft

```solidity
address private immutable i_casterNft;
```


## Functions
### beforeCampaignEnd


```solidity
modifier beforeCampaignEnd();
```

### afterCampaignEnd


```solidity
modifier afterCampaignEnd();
```

### constructor


```solidity
constructor(CasterTypes.CreateCampaign memory _campaignParams);
```

### mintCampaignId

Mints a unique voting id (Nft) to an eligible voter (if the user can prove themselves
to be part of the merkle root supplied by the campaign creator).


```solidity
function mintCampaignId(
    uint256 _votingPower,
    bytes32[] memory _merkleProof,
    string memory _uri
)
    external
    beforeCampaignEnd
    returns (uint256 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_votingPower`|`uint256`|The number of votes the user has.|
|`_merkleProof`|`bytes32[]`|The proof required to prove that the user is a part of the merkle tree.|
|`_uri`|`string`|Preferably, a custom IPFS URI which allows users to set their details for the campaign.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint256`|The unique voting id (Nft) minted.|


### delegateTo

Allows any eligible voter to delegate their votes to a single user.


```solidity
function delegateTo(address _user, uint256 _votes) external beforeCampaignEnd;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user to delegate votes to.|
|`_votes`|`uint256`|The number of votes to delegate.|


### batchDelegate

Allows any eligible voter to delegate their votes to multiple users.


```solidity
function batchDelegate(address[] memory _users, uint256[] memory _votes) external beforeCampaignEnd;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_users`|`address[]`|The user addresses.|
|`_votes`|`uint256[]`|The amount of votes to delegate to different users.|


### voteSingleOption

Allows voters with voting powers (received through the Nft or delegation) to vote in a
single option campaign.


```solidity
function voteSingleOption(bool _isAgainst, uint256 _votes) external beforeCampaignEnd;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_isAgainst`|`bool`|True if against the option, false otherwise.|
|`_votes`|`uint256`|The number of votes to use.|


### voteMultipleOption

Allows voters with voting powers (received through the Nft or delegation) to vote in a
multiple option campaign.


```solidity
function voteMultipleOption(uint256 _index, uint256 _votes) external beforeCampaignEnd;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_index`|`uint256`|The option to vote for.|
|`_votes`|`uint256`|The number of votes to use.|


### getResultSingleOption

Gets the result of a single option voting campaign.


```solidity
function getResultSingleOption() external view afterCampaignEnd returns (CasterTypes.SingleOptionResult result);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`result`|`CasterTypes.SingleOptionResult`|The result -- For (statement agreed with), Against (statement disagreed with), or Tie.|


### getResultMultipleOption

Gets the result of a single option voting campaign.


```solidity
function getResultMultipleOption() external view afterCampaignEnd returns (uint256 index);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`index`|`uint256`|The index of the winning option. type(uint256).max in case of a tie.|


### getCampaignName

Gets the campaign's name.


```solidity
function getCampaignName() external view returns (string memory name);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|A string name.|


### getCampaignDescription

Gets the campaign's description.


```solidity
function getCampaignDescription() external view returns (string memory description);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`description`|`string`|A string description.|


### getCampaignType

Gets the campaign type (single option or multiple option).


```solidity
function getCampaignType() external view returns (CasterTypes.CampaignType campaignType);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`campaignType`|`CasterTypes.CampaignType`|0 for single option and 1 for multiple option campaign.|


### getSingleOption

Gets the single option details.


```solidity
function getSingleOption() external view returns (CasterTypes.SingleOption memory singleOption);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`singleOption`|`CasterTypes.SingleOption`|The SingleOption struct.|


### getMultipleOptions

Gets the multiple options available to vote for in a multiple option campaign.


```solidity
function getMultipleOptions() external view returns (CasterTypes.MultipleOption[] memory multipleOptions);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`multipleOptions`|`CasterTypes.MultipleOption[]`|An array of MultipleOption structs.|


### getMerkleRoot

The merkle root for a campaign. Used to verify/validate eligible users.


```solidity
function getMerkleRoot() external view returns (bytes32 merkleRoot);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`merkleRoot`|`bytes32`|A bytes32 merkle root.|


### getLastTimestamp

The timestamp when the campaign was deployed.


```solidity
function getLastTimestamp() external view returns (uint256 lastTimestamp);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`lastTimestamp`|`uint256`|The UNIX timestamp.|


### getCampaignDuration

Gets the duration for which the campaign will run.


```solidity
function getCampaignDuration() external view returns (uint256 duration);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`duration`|`uint256`|The campaign duration.|


### getCasterNft

Gets the Caster Nft associated with this campaign.


```solidity
function getCasterNft() external view returns (address casterNft);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`casterNft`|`address`|The address of the Caster Nft.|


## Events
### Initialized

```solidity
event Initialized(CasterTypes.CreateCampaign indexed camaignParams, address indexed casterNft);
```

### VoterRegistered

```solidity
event VoterRegistered(address indexed user, uint256 indexed votingPower, uint256 indexed id, bytes32[] merkleProof);
```

### VotingPowerDelegated

```solidity
event VotingPowerDelegated(address indexed by, address indexed to, uint256 indexed votes);
```

### VotingPowerBatchDelegated

```solidity
event VotingPowerBatchDelegated(address indexed by, address[] indexed users, uint256[] indexed votes);
```

### VotedSingleOption

```solidity
event VotedSingleOption(address indexed user, bool indexed isAgainst, uint256 indexed votes);
```

### VotedMultipleOption

```solidity
event VotedMultipleOption(address indexed user, uint256 indexed index, uint256 votes);
```

## Errors
### CasterCampaign__VotingCampaignEnded

```solidity
error CasterCampaign__VotingCampaignEnded();
```

### CasterCampaign__VotingCampaignInProgress

```solidity
error CasterCampaign__VotingCampaignInProgress();
```

### CasterCampaign__VotingIdAlreadyMinted

```solidity
error CasterCampaign__VotingIdAlreadyMinted();
```

### CasterCampaign__InvalidProof

```solidity
error CasterCampaign__InvalidProof();
```

### CasterCampaign__NoChainedDelegationAllowed

```solidity
error CasterCampaign__NoChainedDelegationAllowed();
```

### CasterCampaign__ArraySizesDonotMatch

```solidity
error CasterCampaign__ArraySizesDonotMatch();
```

### CasterCampaign__InvalidVotingMethod

```solidity
error CasterCampaign__InvalidVotingMethod(CasterTypes.CampaignType campaignType);
```

### CasterCampaign__NotRegistered

```solidity
error CasterCampaign__NotRegistered();
```

### CasterCampaign__NotEnoughVotes

```solidity
error CasterCampaign__NotEnoughVotes();
```

### CasterCampaign__InvalidOption

```solidity
error CasterCampaign__InvalidOption();
```

