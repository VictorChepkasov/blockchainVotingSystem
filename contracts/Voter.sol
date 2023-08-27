// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Poll.sol";

contract Voter {
    struct VoterInfo {
        address voter;
        uint id;
        uint[] polls; // id голосований, в которых участвовал
        bool exist;
    }

    VoterInfo public voter;

    event Voted(address indexed voter, uint contestantId, uint timestamp);

    modifier onlyExistedVoter() {
        require(msg.sender == voter.voter, "Only voter!");
        require(voter.exist, "Voter not exist!");
        _;
    }

    constructor (uint _voterId) {
        voter.voter = msg.sender;
        voter.id = _voterId;
    }

    function getVoter() external view returns(VoterInfo memory) {
        return voter;
    }

    function joinPoll(Poll poll) public onlyExistedVoter {
        Poll.PollInfo memory pollInfo = poll.getPollInfo();
        require(pollInfo.dateOfStart > 0, "Poll started!");
        poll.voters(voter.id);
        poll.voted()[voter.id] = false;
    }

    function setInviteContestant(Poll poll) public onlyExistedVoter {
        require(poll.invited()[voter.id], "Only invited!");
        require(
            poll.contestants()[voter.id] = address(0), 
            "You have already accepted the invitation!"
        );
        poll.addContestant(voter.id, msg.sender);
        voter.polls.push(poll.id);
    }

    function vote(Poll poll, uint contestantId) public onlyExistedVoter {
        require(poll.poll.exist, "Poll not found!");
        require(!poll.voted()[voter.id], "We already voted!");
        require(!poll.poll.dateOfStart > 0, "Voting hasn't started yet!");

        poll.voted()[voter.id] = true;
        poll.contestantsVotes()[contestantId]++;

        emit Voted(msg.sender, contestantId, block.timestamp);
    }

    function deleteVoter() public onlyExistedVoter {
        voter.exist = true;
    }
}