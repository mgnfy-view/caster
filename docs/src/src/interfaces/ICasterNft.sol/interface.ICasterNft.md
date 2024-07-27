# ICasterNft
[Git Source](https://github.com/mgnfy-view/caster/blob/d96545b5627fb207f8442947bac4d9f902606cd5/src/interfaces/ICasterNft.sol)


## Functions
### mint


```solidity
function mint(address _user, uint256 _votingPower, string memory _uri) external returns (uint256 id);
```

### increaseVotingPower


```solidity
function increaseVotingPower(address _user, uint256 _amount) external;
```

### decreaseVotingPower


```solidity
function decreaseVotingPower(address _user, uint256 _amount) external;
```

### getNextIdToMint


```solidity
function getNextIdToMint() external view returns (uint256 nextId);
```

### getUserId


```solidity
function getUserId(address _user) external view returns (uint256 id);
```

### getUserVotingPower


```solidity
function getUserVotingPower(address _user) external view returns (uint256 votingPower);
```

