// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

contract Poll {
    address winner;

    struct PollInfo {
        address creator;
        string title;
        uint id;
        uint voters;
        uint countOfContestants;
        uint dateOfCreated;
        uint dateOfStart;
        uint dateOfEnd;
        bool exist;
    }

    mapping(uint => address) public voters;
    mapping(uint => address) public contestants;
    mapping(uint => bool) public voted;
    mapping(uint => bool) public invited; // приглашённые пользователи(true)
    mapping(address => uint) public contestantsVotes;
    address[] public contestantsAddresses;

    PollInfo public poll;

    modifier onlyCreator() {
        require(msg.sender == poll.creator, "Only creator!");
        _;
    }

    constructor(address _creator, string memory _title, uint _pollId) {
        poll.creator = _creator;
        poll.title = _title;
        poll.id = _pollId;
        poll.dateOfCreated = block.timestamp;
        poll.dateOfStart = 0;
        poll.exist = true;
    }

    function getPollInfo() external view returns(PollInfo memory) {
        return poll;
    }

    function getContestant(uint _contestantId) external view returns(address) {
        return contestants[_contestantId];
    }

    function getVoter(uint _voterId) external view returns(address) {
        return voters[_voterId];
    }

    function inviteContestant(uint _contestantId) external {
        invited[_contestantId] = true;
    }

    function vote(uint _voterId, uint _contestantId) external {
        require(voters[_voterId] != address(0), "Voter don't exist!");
        require(voted[_voterId], "You are voted!");
        voted[_voterId] = true;
        contestantsVotes[contestants[_contestantId]]++;
    }

    function joinPoll(uint _voterId, address _voter) external {
        voters[_voterId] = _voter;
        voted[_voterId] = false;
    }

    function addContestant(uint _contestantId, address _contestant) external {
        require(invited[_contestantId], "Contestant don't invited!");
        require(contestants[_contestantId] == address(0), "Contestant exist!");
        contestants[_contestantId] = _contestant;
        contestantsAddresses.push(_contestant);
        contestantsVotes[_contestant] = 0;
    }

    function startContest(uint _dateOfEnd) public {
        require(
            _dateOfEnd > poll.dateOfStart && _dateOfEnd > block.timestamp,
            "Incorrect date of end!"
        );
        poll.dateOfStart = block.timestamp;
    }

    function endContest() public onlyCreator {
        require(block.timestamp > poll.dateOfEnd, "Voting hasn't ended!");
        poll.exist = false;
        // определение победителя голосования
        // winner = адресс участника с наибольшим количеством голосов
    }

    function updateTitle(string memory _title) public onlyCreator {
        require(poll.dateOfStart > 0, "Poll started!");
        require(!poll.exist, "Poll exist!");
        require(bytes(_title).length > 0, "Title can't be empty!");
        poll.title = _title;
    }

    function deletePoll() public {
        require(poll.exist == true, "Poll not exist!");
        poll.exist = false;
    }
}