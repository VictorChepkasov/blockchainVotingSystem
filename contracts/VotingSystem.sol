// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Voter.sol";

contract VotingSystem {
    uint public countOfPolls;
    uint public countOfUsers;

    mapping(uint => Voter.VoterInfo) voters; //адресса всех пользователей
    mapping(uint => Poll) polls; //все голосования 
    
    event CreatePoll(address indexed creator, string title, uint timestamp);

    constructor() {}

    function getPoll(uint pollId) public view returns(Poll) {
        return polls[pollId];
    }

    function getVoter(uint voterId) public view returns(Voter.VoterInfo memory) {
        return voters[voterId];
    }

    function registerVoter() public {
        Voter.VoterInfo memory voter;
        voter.voter = msg.sender;
        voter.id = countOfUsers++;
        voters[voter.id] = voter;
    }

    function createPoll(string memory title) public {
        require(bytes(title).length > 0, "Title can't be empty!");
        Poll poll = new Poll(title, countOfPolls++);
        polls[poll.getPollInfo().id] = poll;

        emit CreatePoll(msg.sender, title, block.timestamp);
    }
}