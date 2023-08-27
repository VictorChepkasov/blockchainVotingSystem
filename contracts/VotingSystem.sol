// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Voter.sol";

contract VotingSystem {
    uint public countOfPolls;
    uint public countOfUsers;

    mapping(address => Voter.VoterInfo) voters; //адресса всех пользователей

    mapping(uint => Poll) polls; //все голосования 
    
    event CreatePoll(address indexed creator, string title, uint timestamp);

    constructor() {}

    function getPoll(uint pollId) public view returns(Poll) {
        return polls[pollId];
    }

    function getVoter(uint voterId) public view returns(Voter) {
        return voter[voterId];
    }

    function registerVoter() public {
        Voter.VoterInfo memory voter;
        voter.voter = msg.sender;
        voter.id = countOfUsers++;
        voters[msg.sender] = voter;
    }

    function createPoll(
        string memory title, 
        uint voterId,
        uint dateOfStart,
        uint dateOfEnd
    )
        public onlyVoter(voterId)
    {
        require(bytes(title).length > 0, "Title can't be empty!");
        require(dateOfStart > 0 && dateOfEnd > dateOfStart, "End must be greater than start!");

        PollInfo memory poll;
        
        poll.id = countOfPolls++;
        poll.title = title;
        poll.creator = msg.sender;
        poll.dateOfStart = dateOfStart;
        poll.dateOfEnd = dateOfEnd;
        poll.timestamp = block.timestamp;
        poll.closed = false;

        polls.push(poll);
        pollExist[poll.id] = true;

        emit CreatePoll(msg.sender, title, block.timestamp);
    }


}