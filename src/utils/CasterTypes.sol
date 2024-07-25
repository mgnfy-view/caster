// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

abstract contract CasterTypes {
    enum CampaignType {
        SingleOption,
        MultipleOption
    }

    struct OptionDetails {
        string name;
        string description;
    }

    struct SingleOption {
        OptionDetails details;
        uint256 votesFor;
        uint256 votesAgainst;
    }

    struct MultipleOption {
        OptionDetails details;
        uint256 votesFor;
    }

    struct CreateCampaign {
        string name;
        string description;
        CasterTypes.CampaignType campaignType;
        CasterTypes.OptionDetails[] options;
        bytes32 merkleRoot;
        uint256 duration;
    }
}
