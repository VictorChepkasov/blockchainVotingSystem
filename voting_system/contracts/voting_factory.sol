// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./voting_system.sol";

contract VotingFactory {
    uint counter;
    address votingSystemAddress;

    VotingSystem[] public VotingSystemArr;
    VotingSystem votingSystem = VotingSystem(votingSystemAddress);

    constructor(address votingSystem) {
        votingSystemAddress = votingSystem;
    }

    function createNewVoting(string memory title,
        uint dateOfStart,
        uint dateOfEnd
    ) public {
        VotingSystem poll = new VotingSystem(title, dateOfStart, dateOfEnd, ++counter);
        VotingSystemArr.push(poll);
    }

    function callUpdatePoll(
        string memory title,
        uint dateOfStart,
        uint dateOfEnd
    ) external {
        votingSystem.updatePoll(title, dateOfStart, dateOfEnd);
    }

    function callDeletePoll() external {
        votingSystem.deletePoll();
    }

    function callGetPoll() external returns(VotingSystem.PollInfo memory) {
        return votingSystem.getPoll();
    }

    function callCreateVoter() external {
        votingSystem.createVoter();
    }

    function callVote(uint id, uint vote_id) external {
        votingSystem.vote(id, vote_id);
    }

    function callListContestants(uint id) external returns(VotingSystem.VoterInfo[] memory) {
        return votingSystem.listContestants(id);
    }
}