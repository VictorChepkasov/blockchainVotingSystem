import pytest 
from random import randint
from brownie import accounts, chain, VotingSystem
from conftest import votingSystemContract
from scripts.pollFunctions import *
from scripts.voterFunctions import *
from scripts.votingSystemFunctions import _params, getPoll, getVoter, createVoter

def randInt():
    return randint(5, 8)

def test_getContestant():
    creatorAccount = accounts[0]
    contestantAccount = accounts[1]
    contestantId = createVoter(contestantAccount)
    title = 'Beat it'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = Poll(getPoll(creatorAccount, pollId))

    poll.inviteContestant(contestantId)
    contestant = Voter(getVoter(contestantAccount, pollId))
    contestant.setInviteContestant(poll.poll)

    contestantAddress = poll.getContestant(contestantId)
    contestantVotes = poll.poll.contestantsVotes(contestantAddress)

    assert contestantAddress == contestantAccount
    assert contestantVotes == 0

def test_getVoter():
    creatorAccount = accounts[0]
    voterAccount = accounts[1]
    voterId = createVoter(voterAccount)
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = Poll(getPoll(creatorAccount, pollId))

    poll.startContest(chain.time()+86400)
    voter = Voter(getVoter(voterAccount, pollId))
    voter.joinPoll(poll.poll)

    voterAddress = poll.poll.voters(voterId)
    voted = poll.poll.voted(voterId)

    assert voterAddress == voterAccount
    assert voted == False

@pytest.mark.parametrize('updatedTitle', ["Jägermeister", pytest.param("", marks=pytest.mark.xfail)])
def test_updateTitle(updatedTitle):
    creatorAccount = accounts[0]
    voterAccount = accounts[1]
    createVoter(voterAccount)
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = Poll(getPoll(creatorAccount, pollId))
    
    poll.updateTitle(updatedTitle)
    pollInfoTitle = poll.getPollInfo()[1]

    assert pollInfoTitle == updatedTitle

def test_endContest():
    creatorAccount = accounts[0]
    title = 'Steel commanders'
    pollId = VotingSystem[-1].createPoll(title, _params(creatorAccount)).return_value
    poll = Poll(getPoll(creatorAccount, pollId))

    votersIds, contestantsIds = [], []

    for j in range(1, 4):
        contestantAccount = accounts[j]
        contestantId = createVoter(contestantAccount)
        poll.inviteContestant(contestantId)
        contestant = Voter(getVoter(contestantAccount, contestantId))
        contestant.setInviteContestant(poll.poll)
        contestantsIds.append(contestantId)

    poll.startContest(chain.time()+86400)

    for i in range(4, 8):
        voterId = createVoter(accounts[i])
        votersIds.append(voterId)
        voter = Voter(getVoter(accounts[i], voterId))
        voter.joinPoll(poll.poll)

    f = 0
    for k in range(4, 8):
        voter = Voter(getVoter(accounts[k], votersIds[f]))
        voter.vote(2, poll.poll)
        f += 1

    chain.sleep(poll.getPollInfo()[-2])
    winnerAddress = poll.endContest()

    assert winnerAddress == accounts[2]