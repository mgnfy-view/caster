# ICasterFactory
[Git Source](https://github.com/mgnfy-view/caster/blob/8657e2d8bdc226333eb8f21b2a1461cea0ac8fff/src/interfaces/ICasterFactory.sol)


## Functions
### createVotingCampaign


```solidity
function createVotingCampaign(CasterTypes.CreateCampaign memory _campaignParams)
    external
    payable
    returns (address votingCampaign);
```

### changeFeeReceiver


```solidity
function changeFeeReceiver(address _newFeeReceiver) external;
```

### getNonceForUser


```solidity
function getNonceForUser(address _user) external view returns (uint256 nonce);
```

### getCampaignFromHash


```solidity
function getCampaignFromHash(bytes32 _hash) external view returns (address campaign);
```

### getCampaignMaxDuration


```solidity
function getCampaignMaxDuration() external pure returns (uint256 maxDuration);
```

### getAllCampaigns


```solidity
function getAllCampaigns() external view returns (address[] memory allCampaigns);
```

### getFeeReceiver


```solidity
function getFeeReceiver() external view returns (address feeReceiver);
```

### getFee


```solidity
function getFee() external pure returns (uint256 fee);
```

