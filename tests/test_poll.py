import pytest 
from brownie import accounts, VotingSystem
from conftest import votingSystemContract
from scripts.VotingSystemFunctions import _params
from scripts.pollFunctions import (
    getContestant,
    getVoter,
    inviteContestant
)
from scripts.voterFunctions import setInviteContestant
from scripts.VotingSystemFunctions import getPoll, getVoter, createVoter

def test_getContestant(votingSystemContract):
    creatorAccount = accounts[0]
    contestantAccount = accounts[1]
    contestantId = createVoter(contestantAccount)
    title = 'Beat it'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = getPoll(creatorAccount, pollId)

    inviteContestant(creatorAccount, contestantId, poll)
    setInviteContestant(contestantAccount, getVoter(contestantAccount, pollId), poll)

    contestantAddress = getContestant(contestantAccount, contestantId, poll)
    contestantVotes = poll.contestantsVotes(contestantAddress)
    
    assert contestantAddress == contestantAccount
    assert contestantVotes == 0