# ICasterCampaign
[Git Source](https://github.com/mgnfy-view/caster/blob/d96545b5627fb207f8442947bac4d9f902606cd5/src/interfaces/ICasterCampaign.sol)


## Functions
### mintCampaignId


```solidity
function mintCampaignId(
    uint256 _votingPower,
    bytes32[] memory _merkleProof,
    string memory _uri
)
    external
    returns (uint256 id);
```

### delegateTo


```solidity
function delegateTo(address _user, uint256 _votes) external;
```

### batchDelegate


```solidity
function batchDelegate(address[] memory _users, uint256[] memory _votes) external;
```

### voteSingleOption


```solidity
function voteSingleOption(bool _isAgainst, uint256 _votes) external;
```

### voteMultipleOption


```solidity
function voteMultipleOption(uint256 _index, uint256 _votes) external;
```

### getResultSingleOption


```solidity
function getResultSingleOption() external view returns (CasterTypes.SingleOptionResult result);
```

### getResultMultipleOption


```solidity
function getResultMultipleOption() external view returns (uint256 index);
```

### getCampaignName


```solidity
function getCampaignName() external view returns (string memory name);
```

### getCampaignDescription


```solidity
function getCampaignDescription() external view returns (string memory description);
```

### getCampaignType


```solidity
function getCampaignType() external view returns (CasterTypes.CampaignType campaignType);
```

### getSingleOption


```solidity
function getSingleOption() external view returns (CasterTypes.SingleOption memory singleOption);
```

### getMultipleOptions


```solidity
function getMultipleOptions() external view returns (CasterTypes.MultipleOption[] memory multipleOptions);
```

### getMerkleRoot


```solidity
function getMerkleRoot() external view returns (bytes32 merkleRoot);
```

### getLastTimestamp


```solidity
function getLastTimestamp() external view returns (uint256 lastTimestamp);
```

### getCampaignDuration


```solidity
function getCampaignDuration() external view returns (uint256 duration);
```

### getCasterNft


```solidity
function getCasterNft() external view returns (address casterNft);
```

