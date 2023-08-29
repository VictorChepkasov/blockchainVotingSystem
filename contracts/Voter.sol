// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Poll.sol";

contract Voter {
    struct VoterInfo {
        address voter;
        uint id;
        uint[] polls; //id of the votes in which he participated
        bool exist;
    }

    VoterInfo public voter;

    event Voted(address indexed voter, uint contestantId, uint timestamp);

    modifier onlyExistedVoter() {
        require(msg.sender == voter.voter, "Only voter!");
        require(voter.exist, "Voter not exist!");
        _;
    }

    constructor () {}

    function init(address _voterAddress, uint _voterId) external {
        voter.voter = _voterAddress;
        voter.id = _voterId;
        voter.exist = true;
    }

    function getVoterInfo() external view returns(VoterInfo memory) {
        return voter;
    }

    /*
    * @param poll not started
    */
    function joinPoll(Poll poll) public onlyExistedVoter {
        Poll.PollInfo memory pollInfo = poll.getPollInfo();
        require(pollInfo.dateOfStart > 0, "Poll not started!");
        poll.joinPoll(voter.id, msg.sender);
    }

    /*
    * @dev Allows the invited user to become a poll contestant
    * @param poll mustn't be started and exist
    */
    function setInviteContestant(Poll poll) public onlyExistedVoter {
        require(poll.invited(voter.id), "Only invited!");
        require(
            poll.contestants(voter.id) == address(0), 
            "You have already accepted the invitation!"
        );
        Poll.PollInfo memory pollInfo = poll.getPollInfo();
        poll.addContestant(voter.id, msg.sender);
        voter.polls.push(pollInfo.id);
    }

    /*
    * @dev vote for a transferred member in a dedicated poll
    * @param poll mustn't be started and exist
    * @param contestantId must contestant in the poll
    */
    function vote(Poll poll, uint contestantId) public onlyExistedVoter {
        Poll.PollInfo memory pollInfo = poll.getPollInfo();
        require(pollInfo.exist, "Poll not found!");
        require(!poll.voted(voter.id), "We already voted!");
        poll.vote(voter.id, contestantId);

        emit Voted(msg.sender, contestantId, block.timestamp);
    }

    function deleteVoter() public onlyExistedVoter {
        voter.exist = false;
    }
}