// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721, ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import { ICasterNft } from "./interfaces/ICasterNft.sol";

/**
 * @title CasterNft.
 * @author mgny-view.
 * @notice Each caster nft is deployed by a Caster campaign and mints unique voting ids (Nfts)
 * which grant voting power to eligible users (users who are part of the supplied merkle tree)
 * for that campaign. The Nft contract is owned by the campaign contract, and most of the verification/
 * validation occurs in the campaign rather than the Nft.
 */
contract CasterNft is ERC721URIStorage, Ownable, ICasterNft {
    uint256 private s_idCounter;
    mapping(address user => uint256 id) private s_userToId;
    mapping(address user => uint256 votingPower) private s_userToVotingPower;

    event VotingPowerIncreased(address indexed user, uint256 indexed amount);
    event VotingPowerDecreased(address indexed user, uint256 indexed amount);

    error CasterNft__VotingIdAlreadyMinted();

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender) { }

    /**
     * @notice Mints a unique voting id (Nft) to a user with a specific number of votes.
     * @param _user The user to mint the voting id to.
     * @param _votingPower The number of votes to provide to the user.
     * @param _uri Preferably, a custom IPFS URI which allows users to set their details for the campaign.
     * @return id The voting id minted to the user.
     */
    function mint(address _user, uint256 _votingPower, string memory _uri) external onlyOwner returns (uint256 id) {
        id = ++s_idCounter;
        s_userToId[_user] = id;
        s_userToVotingPower[_user] = _votingPower;
        _setTokenURI(id, _uri);

        _safeMint(_user, id);
    }

    /**
     * @notice Increases a user's voting power. Used for delegation purposes.
     * @param _user The user's address.
     * @param _amount The number of additional votes to give to the user.
     */
    function increaseVotingPower(address _user, uint256 _amount) external onlyOwner {
        s_userToVotingPower[_user] += _amount;

        emit VotingPowerIncreased(_user, _amount);
    }

    /**
     * @notice Decreases a user's voting power. Used for delegation purposes.
     * @param _user The user's address.
     * @param _amount The number of votes to take from the user.
     */
    function decreaseVotingPower(address _user, uint256 _amount) external onlyOwner {
        s_userToVotingPower[_user] -= _amount;

        emit VotingPowerDecreased(_user, _amount);
    }

    /**
     * @notice Gets the next id to mint.
     * @return nextId The next id.
     */
    function getNextIdToMint() external view returns (uint256 nextId) {
        nextId = s_idCounter + 1;
    }

    /**
     * @notice Gets the user's voting id for the campaign.
     * @param _user The user's address.
     * @return id The user's id.
     */
    function getUserId(address _user) external view returns (uint256 id) {
        id = s_userToId[_user];
    }

    /**
     * @notice Gets the user's voting power for the campaign. Susceptible to changes if delegated.
     * @param _user The user's address.
     * @return votingPower The number of votes a user can vote with.
     */
    function getUserVotingPower(address _user) external view returns (uint256 votingPower) {
        votingPower = s_userToVotingPower[_user];
    }
}
