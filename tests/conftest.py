import pytest
from brownie import accounts
from scripts.deployVotingSystem import deployVotingSystem

@pytest.fixture(autouse=True)
def votingSystemContract():
    return deployVotingSystem(accounts[0])

