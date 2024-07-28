# CasterTypes
[Git Source](https://github.com/mgnfy-view/caster/blob/8657e2d8bdc226333eb8f21b2a1461cea0ac8fff/src/utils/CasterTypes.sol)


## Structs
### OptionDetails

```solidity
struct OptionDetails {
    string name;
    string description;
}
```

### SingleOption

```solidity
struct SingleOption {
    OptionDetails details;
    uint256 votesFor;
    uint256 votesAgainst;
}
```

### MultipleOption

```solidity
struct MultipleOption {
    OptionDetails details;
    uint256 votesFor;
}
```

### CreateCampaign

```solidity
struct CreateCampaign {
    string name;
    string description;
    CasterTypes.CampaignType campaignType;
    CasterTypes.OptionDetails[] options;
    bytes32 merkleRoot;
    uint256 duration;
}
```

## Enums
### CampaignType

```solidity
enum CampaignType {
    SingleOption,
    MultipleOption
}
```

### SingleOptionResult

```solidity
enum SingleOptionResult {
    For,
    Against,
    Tie
}
```

