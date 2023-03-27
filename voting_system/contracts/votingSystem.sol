// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

contract VotingSystem {
    struct PollInfo {
        string title;
        address creator;
        uint id;
        uint votes; //кол-во голосов во всём опросе
        uint contestants; //кол-во человек, за которых голосуют
        // uint countOfVoters; //кол-во голосующих
        uint dateOfStart; //дата начала голосования
        uint dateOfEnd; //дата конца голосования
        uint timestamp; //дата создания голосования
        bool closed; //открыто ли голосование?
    }

    // Эта структура участника голосования, он может быть кандидатом, или просто голосующим
    struct VoterInfo {
        address voter;
        uint id;
        uint votes;  //кол-во голосов
        address[] voters; //адреса тех, кто проголосовал
    }

    uint countOfPolls;
    uint countOfUsers;

    mapping(address => VoterInfo) voters; //адресса всех участников голосования
    mapping(uint => mapping(address => bool)) voted; //проголосовавщие
    mapping(uint => mapping(address => bool)) contested; //участвовал ли в определённом опросе опросе
    mapping(uint => VoterInfo[]) contestants; //данные каждого из участников опроса
    mapping(uint => bool) pollExist; //проверяет, существует ли конкретный опрос

    PollInfo[] polls;

    // Poll functions
    function createPoll(string memory title, 
        uint dateOfStart,
        uint dateOfEnd
    ) public onlyVoter {
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

        emit createVoting(msg.sender, title, block.timestamp);
    }

    function updatePoll(string memory title,
        uint dateOfStart,
        uint dateOfEnd, uint pollId
    ) public OnlyCreator(pollId) {
        require(!polls[pollId].closed, "");
        require(bytes(title).length == 0, "Title can't be empty!");
        require(dateOfEnd > dateOfStart, "End must be greater than start!");

        polls[pollId].title = title;
        polls[pollId].dateOfStart = dateOfStart;
        polls[pollId].dateOfEnd = dateOfEnd;
    }

    function deletePoll(uint pollId) public OnlyCreator(pollId) {
        require(pollExist[pollId] == true, "Poll not found!");
        polls[pollId].closed = true;
    }

    function getPoll(uint pollId) public view returns(PollInfo memory) {
        return polls[pollId];
    }

    function getAllPolls() public view returns(PollInfo[] memory) {
        return polls;
    }

    // Voter functions
    function registerVoter() public {
        VoterInfo memory voter;

        voter.id = countOfUsers++;
        voter.voter = msg.sender;
        voters[msg.sender] = voter;
    }

    function vote(uint pollId, uint contestantId) public onlyVoter {
        require(pollExist[pollId], "Poll not found!");
        require(!voted[pollId][msg.sender], "We already voted!");
        require(!polls[pollId].closed, "Voting hasn't started yet!");
        require(polls[pollId].dateOfEnd > polls[pollId].dateOfStart, "End must be greater than start!");

        voted[pollId][msg.sender] = true;
        //я так понял что voter = contestants[id][vote_id], не сильно понимаю почему, но вот так вот
        contestants[pollId][contestantId].votes++; //прибавление голосов кандидату
        contestants[pollId][contestantId].voters.push(msg.sender); //добавление адреса участника голосовани кандидату 
        polls[pollId].votes++;

        emit Voted(msg.sender, block.timestamp);
    }
        
    function listContestants(uint contestantId) public returns(VoterInfo[] memory) {
        return contestants[contestantId];
    }

    event createVoting(address indexed creator, string title, uint timestamp);
    event Voted(address indexed voter, uint timestamp);

    modifier onlyVoter() {
        msg.sender == voters[msg.sender].voter;
        _;
    }

    modifier OnlyCreator(uint pollId) {
        msg.sender == polls[pollId].creator;
        _;
    }
}