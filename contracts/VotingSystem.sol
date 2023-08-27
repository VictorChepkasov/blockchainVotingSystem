// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Voter.sol";

// cloneFactory для голосований и пользователей

contract VotingSystem {
    uint public countOfPolls;
    uint public countOfUsers;

    mapping(uint => Voter) voters; //адресса всех пользователей
    mapping(uint => Poll) polls; //все голосования 
    
    event CreatePoll(address indexed creator, string title, uint dateOfCreate);
    event CreateVoter(address indexed voter, uint voterId, uint dateOfCreate);

    constructor() {}

    function getPoll(uint pollId) public view returns(Poll) {
        return polls[pollId];
    }

    function getVoter(uint voterId) public view returns(Voter) {
        return voters[voterId];
    }

    function createVoter() public {
        uint voterId = countOfUsers++;
        Voter voter = new Voter(msg.sender, voterId);
        voters[voterId] = voter;

        emit CreateVoter(msg.sender, voterId, block.timestamp);
    }

    function createPoll(string memory title) public {
        require(bytes(title).length > 0, "Title can't be empty!");
        Poll poll = new Poll(msg.sender, title, countOfPolls++);
        polls[poll.getPollInfo().id] = poll;

        emit CreatePoll(msg.sender, title, block.timestamp);
    }
}