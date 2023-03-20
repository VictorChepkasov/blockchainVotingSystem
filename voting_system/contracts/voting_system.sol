// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

contract VotingSystem {
    struct PollInfo {
        string title;
        address creator;
        uint id;
        uint votes; //кол-во голосов во всём опросе
        uint contestants; //кол-во человек, за которых голосуют
        uint countOfVoters; //кол-во голосующих
        uint dateOfStart; //дата начала голосования
        uint dateOfEnd; //дата конца голосования
        uint timestamp; //дата создания голосования
        bool opened; //открыто ли голосование?
    }

    // Эта структура участника голосования, он может быть кандидатом, или просто голосующим
    struct VoterInfo {
        address voter;
        bool voted;
        uint id;
        uint votes;  //кол-во голосов
        address[] voters; //адреса тех, кто проголосовал
    }

    PollInfo public poll;

    mapping(address => VoterInfo) voters; //адресса всех участников голосования
    mapping(uint => mapping(address => bool)) voted; //проголосовавщие
    mapping(uint => VoterInfo[]) contestants; //ребята за которых голосуют

    // Poll functions
    constructor(string memory title,
        uint dateOfStart,
        uint dateOfEnd, uint id
    ) {
        require(bytes(title).length > 0, "Title can't be empty!");
        require(dateOfStart > 0 && dateOfEnd > dateOfStart, "End must be greater than start!");        

        poll.title = title;
        poll.creator = msg.sender;
        poll.dateOfStart = dateOfStart;
        poll.dateOfEnd = dateOfEnd;
        poll.timestamp = block.timestamp;
        poll.opened = false;
        poll.id = id;

        emit createVoting(msg.sender, title, block.timestamp);
    }

    function updatePoll(string memory title,
        uint dateOfStart,
        uint dateOfEnd
    ) public OnlyCreator {
        require(poll.opened == false, "");
        require(bytes(title).length == 0, "Title can't be empty!");
        require(dateOfEnd > dateOfStart, "End must be greater than start!");

        poll.title = title;
        poll.dateOfStart = dateOfStart;
        poll.dateOfEnd = dateOfEnd;
    }

    function deletePoll() public OnlyCreator {
        poll.opened = false;
    }

    function getPoll() public view returns(PollInfo memory) {
        return poll;
    }

    // Voter functions
    function createVoter() public {
        VoterInfo memory voter;

        voter.id = poll.countOfVoters++;
        voter.voter = msg.sender;
    }

    function vote(uint id, uint vote_id) public onlyVoter {
        require(!voters[msg.sender].voted, "We already voted!");
        require(poll.opened = true, "Voting hasn't started yet!");
        require(poll.dateOfEnd > poll.dateOfStart, "End must be greater than start!");

        voted[id][msg.sender] = true;
        //я так понял что voter = contestants[id][vote_id], не сильно понимаю почему, но вот так вот
        contestants[id][vote_id].votes++; //прибавление голосов кандидату
        contestants[id][vote_id].voters.push(msg.sender); //добавление адреса участника голосовани кандидату 
        poll.votes++;

        emit Voted(msg.sender, block.timestamp);
    }

    function listContestants(uint id) public returns(VoterInfo[] memory) {
        return contestants[id];
    }

    event createVoting(address indexed creator, string title, uint timestamp);
    event Voted(address indexed voter, uint timestamp);

    modifier onlyVoter() {
        msg.sender == voters[msg.sender].voter;
        _;
    }

    modifier OnlyCreator() {
        msg.sender == poll.creator;
        _;
    }
}