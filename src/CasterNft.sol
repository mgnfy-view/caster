// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721, ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import { ICasterNft } from "./interfaces/ICasterNft.sol";

contract CasterNft is ERC721URIStorage, Ownable, ICasterNft {
    uint256 private s_idCounter;
    mapping(address user => uint256 id) private s_userToId;
    mapping(address user => uint256 votingPower) s_userToVotingPower;

    event VotingPowerIncreased(address indexed user, uint256 indexed amount);
    event VotingPowerDecreased(address indexed user, uint256 indexed amount);

    error CasterNft__VotingIdAlreadyMinted();

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender) { }

    function mint(address _user, uint256 _votingPower, string memory _uri) external onlyOwner returns (uint256 id) {
        id = ++s_idCounter;
        s_userToId[_user] = id;
        s_userToVotingPower[_user] = _votingPower;
        _setTokenURI(id, _uri);

        _safeMint(_user, id);
    }

    function increaseVotingPower(address _user, uint256 _amount) external onlyOwner {
        s_userToVotingPower[_user] += _amount;

        emit VotingPowerIncreased(_user, _amount);
    }

    function decreaseVotingPower(address _user, uint256 _amount) external onlyOwner {
        s_userToVotingPower[_user] -= _amount;

        emit VotingPowerDecreased(_user, _amount);
    }

    function getNextIdToMint() external view returns (uint256 nextId) {
        nextId = s_idCounter + 1;
    }

    function getUserId(address _user) external view returns (uint256 id) {
        id = s_userToId[_user];
    }

    function getUserVotingPower(address _user) external view returns (uint256 votingPower) {
        votingPower = s_userToVotingPower[_user];
    }
}
