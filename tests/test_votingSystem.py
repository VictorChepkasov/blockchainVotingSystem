import pytest
from brownie import accounts, chain
from conftest import votingSystemContract
from scripts.VotingSystemFunctions import (
    getVoter,
    getPoll,
    createVoter,
    createPoll
)
from scripts.voterFunctions import getVoterInfo
from scripts.pollFunctions import getPollInfo

def test_createVoter():
    account = accounts[0]
    voterId = createVoter(account)
    voterInfo = list(getVoterInfo(account, getVoter(account, voterId)))
    assert voterInfo == [account, 1, (), True]

@pytest.mark.parametrize('title', ["I've got you surrounded", pytest.param("", marks=pytest.mark.xfail)])
def test_createPoll(title):
    account = accounts[0]
    pollId = createPoll(account, title)
    pollInfo = list(getPollInfo(account, getPoll(account, pollId)))
    pollInfo[5] //= 3600
    assert pollInfo == [account, title, 1, 0, 0, chain.time() // 3600, 0, 0, True]

