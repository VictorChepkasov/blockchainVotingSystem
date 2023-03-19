// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./voting_system.sol";

contract Factory {
    address votingSystemAddress;
    VotingSystem[] public VotingSystemArr;

    constructor(address votingSystem) {
        votingSystemAddress = votingSystem;
    }


    function createNewVoting(string memory title,
        uint dateOfStart,
        uint dateOfEnd
    ) public {
        VotingSystem poll = new VotingSystem(title, dateOfStart, dateOfEnd);
        VotingSystemArr.push(poll);
    }

    function getPoll() external returns(VotingSystem.PollInfo memory) {
        VotingSystem votingSystem = VotingSystem(votingSystemAddress);
        return votingSystem.getPoll();
    }
    
}