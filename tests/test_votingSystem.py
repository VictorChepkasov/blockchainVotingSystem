import pytest
from brownie import accounts, chain
from conftest import votingSystemContract
from scripts.voterFunctions import *
from scripts.pollFunctions import *
from scripts.votingSystemFunctions import (
    getVoter,
    getPoll,
    createVoter,
    createPoll
)

def test_createVoter():
    account = accounts[0]
    voterId = createVoter(account)
    voter = Voter(getVoter(account, voterId))
    voterInfo = list(voter.getVoterInfo())
    assert voterInfo == [account, 1, (), True]

@pytest.mark.parametrize('title', ["I've got you surrounded", pytest.param("", marks=pytest.mark.xfail)])
def test_createPoll(title):
    account = accounts[0]
    pollId = createPoll(account, title)
    poll = Poll(getPoll(account, pollId))
    pollInfo = list(poll.getPollInfo())
    pollInfo[5] //= 3600
    assert pollInfo == [account, title, 1, 0, 0, chain.time() // 3600, 0, 0, True]

