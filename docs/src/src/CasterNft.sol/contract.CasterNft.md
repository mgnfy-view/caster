# CasterNft
[Git Source](https://github.com/mgnfy-view/caster/blob/8657e2d8bdc226333eb8f21b2a1461cea0ac8fff/src/CasterNft.sol)

**Inherits:**
ERC721URIStorage, Ownable, [ICasterNft](/src/interfaces/ICasterNft.sol/interface.ICasterNft.md)

**Author:**
mgny-view.

Each caster nft is deployed by a Caster campaign and mints unique voting ids (Nfts)
which grant voting power to eligible users (users who are part of the supplied merkle tree)
for that campaign. The Nft contract is owned by the campaign contract, and most of the verification/
validation occurs in the campaign rather than the Nft.


## State Variables
### s_idCounter

```solidity
uint256 private s_idCounter;
```


### s_userToId

```solidity
mapping(address user => uint256 id) private s_userToId;
```


### s_userToVotingPower

```solidity
mapping(address user => uint256 votingPower) private s_userToVotingPower;
```


## Functions
### constructor


```solidity
constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender);
```

### mint

Mints a unique voting id (Nft) to a user with a specific number of votes.


```solidity
function mint(address _user, uint256 _votingPower, string memory _uri) external onlyOwner returns (uint256 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user to mint the voting id to.|
|`_votingPower`|`uint256`|The number of votes to provide to the user.|
|`_uri`|`string`|Preferably, a custom IPFS URI which allows users to set their details for the campaign.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint256`|The voting id minted to the user.|


### increaseVotingPower

Increases a user's voting power. Used for delegation purposes.


```solidity
function increaseVotingPower(address _user, uint256 _amount) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user's address.|
|`_amount`|`uint256`|The number of additional votes to give to the user.|


### decreaseVotingPower

Decreases a user's voting power. Used for delegation purposes.


```solidity
function decreaseVotingPower(address _user, uint256 _amount) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user's address.|
|`_amount`|`uint256`|The number of votes to take from the user.|


### getNextIdToMint

Gets the next id to mint.


```solidity
function getNextIdToMint() external view returns (uint256 nextId);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`nextId`|`uint256`|The next id.|


### getUserId

Gets the user's voting id for the campaign.


```solidity
function getUserId(address _user) external view returns (uint256 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user's address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint256`|The user's id.|


### getUserVotingPower

Gets the user's voting power for the campaign. Susceptible to changes if delegated.


```solidity
function getUserVotingPower(address _user) external view returns (uint256 votingPower);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|The user's address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`votingPower`|`uint256`|The number of votes a user can vote with.|


## Events
### VotingPowerIncreased

```solidity
event VotingPowerIncreased(address indexed user, uint256 indexed amount);
```

### VotingPowerDecreased

```solidity
event VotingPowerDecreased(address indexed user, uint256 indexed amount);
```

## Errors
### CasterNft__VotingIdAlreadyMinted

```solidity
error CasterNft__VotingIdAlreadyMinted();
```

