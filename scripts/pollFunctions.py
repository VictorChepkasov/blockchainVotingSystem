import pytest
from brownie import Poll
from .VotingSystemFunctions import _params

def getPollInfo(_from, poll):
    pollInfo = poll.getPollInfo(_params(_from))
    print(f'Poll info: {pollInfo}')
    return pollInfo