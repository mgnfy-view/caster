# CasterFactory
[Git Source](https://github.com/mgnfy-view/caster/blob/8657e2d8bdc226333eb8f21b2a1461cea0ac8fff/src/CasterFactory.sol)

**Inherits:**
Ownable, [ICasterFactory](/src/interfaces/ICasterFactory.sol/interface.ICasterFactory.md)

**Author:**
mgnfy-view.

This contract is the entry point to the Caster protocol. Any user can create voting
campaigns in a permissionless manner.


## State Variables
### s_nonces

```solidity
mapping(address user => uint256 nonce) private s_nonces;
```


### s_hashToCampaign

```solidity
mapping(bytes32 hash => address campaign) private s_hashToCampaign;
```


### MAX_DURATION

```solidity
uint256 private constant MAX_DURATION = 365 days;
```


### s_allCampaigns

```solidity
address[] private s_allCampaigns;
```


### s_feeReceiver

```solidity
address private s_feeReceiver;
```


### FEE

```solidity
uint256 private constant FEE = 0.001 ether;
```


## Functions
### constructor


```solidity
constructor(address _feeReceiver) Ownable(msg.sender);
```

### createVotingCampaign

Allows anyone to deploy a new voting campaign by paying a small fee.


```solidity
function createVotingCampaign(CasterTypes.CreateCampaign memory _campaignParams)
    external
    payable
    returns (address votingCampaign);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_campaignParams`|`CasterTypes.CreateCampaign`|The parameters for the campaign creation.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`votingCampaign`|`address`|The address of the deployed voting campaign.|


### changeFeeReceiver

Allows the owner to change the fee receiver address.


```solidity
function changeFeeReceiver(address _newFeeReceiver) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newFeeReceiver`|`address`|The new fee receiver's address.|


### getNonceForUser

Gets the nonce of the user.


```solidity
function getNonceForUser(address _user) external view returns (uint256 nonce);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user's address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`nonce`|`uint256`|The nonce value.|


### getCampaignFromHash

Gets the address of the deployed campaign from the supplied hash.


```solidity
function getCampaignFromHash(bytes32 _hash) external view returns (address campaign);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_hash`|`bytes32`|The hash of the campaign generated using keccak256(abi.encode(owner, campaignName, merkleRoot, nonce)).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`campaign`|`address`|The campaign's address.|


### getCampaignMaxDuration

Gets the max duration any campaign can run for.


```solidity
function getCampaignMaxDuration() external pure returns (uint256 maxDuration);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`maxDuration`|`uint256`|The max duration.|


### getAllCampaigns

Gets addresses of all campaigns deployed so far. Useful for UI development purposes.


```solidity
function getAllCampaigns() external view returns (address[] memory allCampaigns);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`allCampaigns`|`address[]`|Addresses of all campaigns deployed so far.|


### getFeeReceiver

Gets the fee receiver's address.


```solidity
function getFeeReceiver() external view returns (address feeReceiver);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`feeReceiver`|`address`|The fee receiver's address.|


### getFee

Gets the fee to pay in native currency while deploying a campaign.


```solidity
function getFee() external pure returns (uint256 fee);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee value.|


## Events
### VotingCampaignCreated

```solidity
event VotingCampaignCreated(
    address indexed creator,
    CasterTypes.CreateCampaign campaignParams,
    address indexed campaignAddress,
    bytes32 indexed merkleRoot,
    bytes32 campaignHash
);
```

### FeeReceiverChanged

```solidity
event FeeReceiverChanged(address indexed feeReceiver);
```

## Errors
### CasterFactory__InsufficientFeeSupplied

```solidity
error CasterFactory__InsufficientFeeSupplied();
```

### CasterFactory__InvalidVotingCampaignParams

```solidity
error CasterFactory__InvalidVotingCampaignParams();
```

### CasterFactory__TransferFailed

```solidity
error CasterFactory__TransferFailed();
```

