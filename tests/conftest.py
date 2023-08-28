import pytest
from brownie import accounts
from scripts.deployVotingSystem import deployVotingSystem

@pytest.fixture(scope='session')
def votingSystemContract():
    return deployVotingSystem(accounts[0])
