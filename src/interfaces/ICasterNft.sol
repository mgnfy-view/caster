// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface ICasterNft {
    function mint(address _user, uint256 _votingPower, string memory _uri) external returns (uint256 id);

    function decreaseVotingPower(address _user, uint256 _amount) external;

    function increaseVotingPower(address _user, uint256 _amount) external;

    function getNextIdToMint() external view returns (uint256 nextId);

    function getUserId(address _user) external view returns (uint256 id);

    function getUserVotingPower(address _user) external view returns (uint256 votingPower);
}
