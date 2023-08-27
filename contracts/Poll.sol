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
    mapping(uint => bool) public voted;
    mapping(uint => bool) public invited;
    mapping(uint => address) public contestants;
    mapping(address => uint) public contestantsVotes;
    address[] public contestantsAddresses;

    PollInfo public poll;

    modifier onlyCreator() {
        require(msg.sender == poll.creator, "Only creator!");
        _;
    }

    constructor(string memory _title, uint _pollId) {
        poll.creator = msg.sender;
        poll.title = _title;
        poll.id = _pollId;
        poll.dateOfCreated = block.timestamp;
        poll.dateOfStart = 0;
        poll.exist = true;
    }

    function getPollInfo() external view returns(PollInfo memory) {
        return poll;
    }

    function getContestant(uint contestantId) external view returns(address) {
        return contestants[contestantId];
    }

    function getVoters(uint voterId) external view returns(address) {
        return voters[voterId];
    }

    function inviteContestant(uint contestantId) external {
        invited[contestantId] = true;
    }

    function vote(uint _voterId, uint _contestantId) external {
        voted[_voterId] = true;
        contestantsVotes[contestants[_contestantId]]++;
    }

    function joinPoll(uint _voterId, address _voter) external {
        voters[_voterId] = _voter;
        voted[_voterId] = false;
    }

    function addContestant(uint _contestantId, address _contestant) external {
        require(invited[_contestantId], "Contestant don't invited!");
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
        poll.exist = false;
        // winner = адресс участника с наибольшим количеством голосов
    }

    function updateTitle(
        string memory _title
    )
        public onlyCreator
    {
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