// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

contract VotingSystem {
    struct PollInfo {
        string title;
        address creator;
        uint id;
        uint dateOfStart;
        uint dateOfEnd;
        uint timestamp; 
        uint countOfVoters;
        uint countOfChoices;
        bool opened; //открыто ли голосование?
    }

    struct VoterInfo {
        address voter;
        uint vote;
        bool voted;
    }

    // Голосование может иметь больше одного варианата выбора.
    // Каждый вариант имеет название, свой id, благодаря которому 
    // будут присваиваться голоса, и кол-во голосов.
    struct ChoiceInfo {
        string title;
        uint id;
        uint votes;
    }

    ChoiceInfo[] choices;
    PollInfo[] polls;

    mapping(address => VoterInfo) voters;
    mapping(address => bool) voted;
    mapping(address => ChoiceInfo) voteChoiceArr;

    constructor(){}

    function createPoll(
        string memory title,
        uint dateOfStart,
        uint dateOfEnd,
        uint totalCountOfChoices,
        string[] memory titles
    ) public {
        require(bytes(title).length > 0, "Title can't be empty!");
        require(dateOfStart > 0 && dateOfEnd > dateOfStart, "End must be greater than start!");

        PollInfo memory poll;

        poll.title = title;
        poll.creator = msg.sender;
        poll.dateOfStart = dateOfStart;
        poll.dateOfEnd = dateOfEnd;
        poll.timestamp = block.timestamp;
        poll.countOfVoters = 0;
        poll.countOfChoices = 0;
        poll.opened = false; 

        for(uint i = 0; i<totalCountOfChoices+1; i++) {
            _createChoice(titles[i], i);
            poll.countOfChoices++;
        }       
   }

    function _createChoice(string memory title, uint countOfChoices) private {
        ChoiceInfo memory choice;

        choice.title = title;
        choice.id = countOfChoices++;
        choices.push(choice);
    }

    function vote(uint id, address voter, uint vote_id) public {
        require(voters[msg.sender].voted != true, "Already voted!");
        require(polls[id].opened != true, "Polling already ended!");
        require(polls[id].dateOfEnd > polls[id].dateOfStart, "End date must be greater than start date");

        // тут функционал для отдавания голоса какому-то из вариантов
    }

    function getPoll(uint id) public view returns (PollInfo memory) {
        return polls[id];
    }

    function getVoter(address voter) public view returns(VoterInfo memory) {
        return voters[voter];
    }

    modifier OnlyVoter() {
        msg.sender == voters[msg.sender].voter;
        _;
    }
}