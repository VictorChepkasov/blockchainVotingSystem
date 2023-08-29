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

    // @dev Contains the voters and contestants of this poll: voter/contestant id => voter/contestant address. 
    mapping(uint => address) public voters;
    mapping(uint => address) public contestants;
    // @dev user id => does the user participate in the poll?
    mapping(uint => bool) public voted;
    // @dev user id => whether the user is invited as a contestant?
    mapping(uint => bool) public invited;
    // @dev cpntestant id => the number of contestant votes 
    mapping(address => uint) public contestantsVotes;
    // @dev array of addresses of contestants to determine the winner
    address[] public contestantsAddresses;

    PollInfo public poll;

    modifier onlyCreator() {
        require(msg.sender == poll.creator, "Only creator!");
        _;
    }

    // @dev function with this modifier is used before contest starts
    modifier contestNotStart() {
        require(poll.dateOfStart == 0, "Voting need doesn't start!");
        _;
    }

    // @dev function with this modifier is used after contest started
    modifier contestUnderway() {
        require(poll.dateOfStart > 0, "Voting need start!");
        if (poll.dateOfEnd > block.timestamp) {
            _;
        } else {
            endContest();
        }
    }

    constructor() {}

    /*
    * @param _creator transferred by the factory
    * @param _title can't be empty string
    * @param _pollId transferred by the factory
    */
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

    // @dev function for change values in invited mapping
    function inviteContestant(uint _contestantId) external contestNotStart {
        invited[_contestantId] = true;
    }

    /* @dev function for change values in contestantsVotes and voted mappings
    * @param _voterId:
    *    1. Must lead to an address in the voters mapping
    *    2. The user with this id hasn't voted yet
    * @param _contestantId must lead to an address in the contestants mapping
    */
    function vote(uint _voterId, uint _contestantId) external contestUnderway {
        require(voters[_voterId] != address(0), "Voter don't exist!");
        require(!voted[_voterId], "You're voted!");
        voted[_voterId] = true;
        contestantsVotes[contestants[_contestantId]]++;
    }

    /*
    * @dev function for change values in voter and voted mappings
    * @param _voterId must be equal zero address in voters mapping
    * @param _voter must be equal false in voted mapping
    */
    function joinPoll(uint _voterId, address _voter) external contestUnderway {
        require(voters[_voterId] == address(0), "Voter joined to poll!");
        voters[_voterId] = _voter;
        voted[_voterId] = false;
    }

    /*
    * @dev function for change values in contestants, contestantsVotes mappings,  contestantsAddresses array and increment contestants counter
    */
    function addContestant(uint _contestantId, address _contestant) external contestNotStart {
        require(invited[_contestantId], "Contestant don't invited!");
        require(contestants[_contestantId] == address(0), "Contestant exist!");
        require(voters[_contestantId] == address(0), "Contestant it's voter!");
        contestants[_contestantId] = _contestant;
        contestantsAddresses.push(_contestant);
        contestantsVotes[_contestant] = 0;
        poll.contestants++;
    }

    // @param _title can't be empty string
    function updateTitle(string memory _title) public onlyCreator contestNotStart {
        require(poll.exist, "Poll don't exist!");
        require(bytes(_title).length > 0, "Title can't be empty!");
        poll.title = _title;
    }

    /*
    * @dev poll.dateOfStart must equal zero
    * @notice function is used Creator before voting starts 
    * @param _dateOfEnd must be greater than zero and current time
    */ 
    function startContest(uint _dateOfEnd) public onlyCreator contestNotStart {
        require(
            _dateOfEnd > 0 && _dateOfEnd > block.timestamp,
            "Incorrect date of end!"
        );
        poll.dateOfEnd = _dateOfEnd;
        poll.dateOfStart = block.timestamp;
    }

    /*
    * @notice poll must end^ currect time greater date of end
    * @return address poll winner
    */
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

    // @noice Сreator can delete poll before it starts
    function deletePoll() public onlyCreator contestNotStart {
        require(poll.exist == true, "Poll not exist!");
        poll.exist = false;
    }
}