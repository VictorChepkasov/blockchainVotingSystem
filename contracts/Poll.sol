// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

contract Poll {
    address winner;

    struct PollInfo {
        address creator;
        string title;
        uint id;
        uint voters;
        uint contestants;
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

    modifier contestNotStart() {
        require(poll.dateOfStart == 0, "Voting need doesn't start!");
        _;
    }

    modifier contestUnderway() {
        require(poll.dateOfStart > 0, "Voting need start!");
        if (poll.dateOfEnd > block.timestamp) {
            _;
        } else {
            endContest();
        }
    }

    constructor() {}

    function init(address _creator, string memory _title, uint _pollId) external {
        poll.creator = _creator;
        poll.title = _title;
        poll.id = _pollId;
        poll.dateOfCreated = block.timestamp;
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

    function inviteContestant(uint _contestantId) external contestNotStart {
        invited[_contestantId] = true;
    }

    function vote(uint _voterId, uint _contestantId) external contestUnderway {
        require(voters[_voterId] != address(0), "Voter don't exist!");
        require(!voted[_voterId], "You're voted!");
        voted[_voterId] = true;
        contestantsVotes[contestants[_contestantId]]++;
    }

    function joinPoll(uint _voterId, address _voter) external contestUnderway {
        voters[_voterId] = _voter;
        voted[_voterId] = false;
    }

    function addContestant(uint _contestantId, address _contestant) external contestNotStart {
        require(invited[_contestantId], "Contestant don't invited!");
        require(contestants[_contestantId] == address(0), "Contestant exist!");
        require(voters[_contestantId] == address(0), "Contestant it's voter!");
        contestants[_contestantId] = _contestant;
        contestantsAddresses.push(_contestant);
        contestantsVotes[_contestant] = 0;
        poll.contestants++;
    }

    function updateTitle(string memory _title) public onlyCreator contestNotStart {
        require(poll.exist, "Poll don't exist!");
        require(bytes(_title).length > 0, "Title can't be empty!");
        poll.title = _title;
    }

    function startContest(uint _dateOfEnd) public onlyCreator contestNotStart {
        require(
            _dateOfEnd > poll.dateOfStart && _dateOfEnd > block.timestamp,
            "Incorrect date of end!"
        );
        poll.dateOfEnd = _dateOfEnd;
        poll.dateOfStart = block.timestamp;
    }

    function endContest() public returns(address) {
        require(block.timestamp > poll.dateOfEnd, "Voting hasn't ended!");
        poll.exist = false;
        uint winnerVotes = 0; 
        address winnerAddress;

        for(uint i = 0; i < contestantsAddresses.length; i++){
            if(contestantsVotes[contestantsAddresses[i]] > winnerVotes) {
                winnerVotes = contestantsVotes[contestantsAddresses[i]];
                winnerAddress = contestantsAddresses[i];
            } 
        }

        winner = winnerAddress;
        return winner;
    }

    function deletePoll() public onlyCreator contestUnderway {
        require(poll.exist == true, "Poll not exist!");
        poll.exist = false;
    }
}