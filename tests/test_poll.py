import pytest 
from random import randint
from brownie import accounts, chain, VotingSystem
from conftest import votingSystemContract
from scripts.VotingSystemFunctions import _params
from scripts.pollFunctions import (
    getContestant,
    getVoter,
    getPollInfo,
    inviteContestant,
    updateTitle,
    startContest,
    endContest
)
from scripts.voterFunctions import getVoterInfo, setInviteContestant, joinPoll, vote
from scripts.VotingSystemFunctions import getPoll, getVoter, createVoter

def randInt():
    return randint(5, 8)

def test_getContestant():
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

def test_getVoter():
    creatorAccount = accounts[0]
    voterAccount = accounts[1]
    voterId = createVoter(voterAccount)
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = getPoll(creatorAccount, pollId)

    startContest(creatorAccount, chain.time()+86400, poll)
    joinPoll(voterAccount, getVoter(voterAccount, voterId), poll)

    voterAddress = poll.voters(voterId)
    voted = poll.voted(voterId)

    assert voterAddress == voterAccount
    assert voted == False

@pytest.mark.parametrize('updatedTitle', ["Jägermeister", pytest.param("", marks=pytest.mark.xfail)])
def test_updateTitle(updatedTitle):
    creatorAccount = accounts[0]
    voterAccount = accounts[1]
    createVoter(voterAccount)
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = getPoll(creatorAccount, pollId)
    
    updateTitle(creatorAccount, updatedTitle, poll)
    pollInfoTitle = getPollInfo(creatorAccount, poll)[1]

    assert pollInfoTitle == updatedTitle

def test_endContest():
    creatorAccount = accounts[0]
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = getPoll(creatorAccount, pollId)

    votersIds, contestantsIds = [], []

    for j in range(1, 4):
        contestantAccount = accounts[j]
        contestantId = createVoter(contestantAccount)
        inviteContestant(creatorAccount, contestantId, poll)
        setInviteContestant(contestantAccount, getVoter(contestantAccount, contestantId), poll)
        contestantsIds.append(contestantId)

    startContest(creatorAccount, chain.time()+86400, poll)

    for i in range(4, 8):
        voterId = createVoter(accounts[i])
        votersIds.append(voterId)
        joinPoll(accounts[i], getVoter(accounts[i], voterId), poll)

    f = 0
    for k in range(4, 8):
        voter = getVoter(accounts[k], votersIds[f])
        f += 1
        getVoterInfo(accounts[k], voter)
        vote(accounts[k], 2, voter, poll)

    chain.sleep(getPollInfo(creatorAccount, poll)[-2])
    winnerAddress = endContest(creatorAccount, poll)

    assert winnerAddress == accounts[2]