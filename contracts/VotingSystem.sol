// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./Voter.sol";

// clone factory copy-pasted by github.com/optionality
contract CloneFactory {
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }

    function isClone(address target, address query) internal view returns (bool result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
            mstore(add(clone, 0xa), targetBytes)
            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            let other := add(clone, 0x40)
            extcodecopy(query, other, 0, 0x2d)
            result := and(
                eq(mload(clone), mload(other)),
                eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
            )
        }
    }
}

contract VotingSystem is CloneFactory {
    address pollMasterContract;
    address voterMasterContract;
    uint public countOfPolls;
    uint public countOfUsers;

    mapping(uint => Voter) voters; //адресса всех пользователей
    mapping(address => bool) voterCreated; // для проверки на наличие
    mapping(uint => Poll) polls; //все голосования 
    
    event CreatePoll(address indexed creator, string title, uint dateOfCreate);
    event CreateVoter(address indexed voter, uint voterId, uint dateOfCreate);

    constructor(address _pollMasterContract, address _voterMasterContract) {
        pollMasterContract = _pollMasterContract;
        voterMasterContract = _voterMasterContract;
    }

    function getPoll(uint pollId) public view returns(Poll) {
        return polls[pollId];
    }

    function getVoter(uint voterId) public view returns(Voter) {
        return voters[voterId];
    }

    function createVoter() public returns(uint voterId) {
        require(!voterCreated[msg.sender], "Voter created!");
        voterCreated[msg.sender] = true;
        voterId = ++countOfUsers;
        Voter voter = Voter(createClone(voterMasterContract));
        voter.init(msg.sender, voterId);
        voters[voterId] = voter;

        emit CreateVoter(msg.sender, voterId, block.timestamp);
    }

    function createPoll(string memory title) public returns(uint pollId) {
        require(bytes(title).length > 0, "Title can't be empty!");
        pollId = ++countOfPolls;
        Poll poll = Poll(createClone(pollMasterContract));
        poll.init(msg.sender, title, pollId);
        polls[pollId] = poll;

        emit CreatePoll(msg.sender, title, block.timestamp);
    }
}