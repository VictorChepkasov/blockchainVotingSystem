from brownie import Voter
from .VotingSystemFunctions import _params

def getVoterInfo(_from, _voter):
    voterInfo = _voter.getVoterInfo(_params(_from))
    print(f'Voter info: {voterInfo}')
    return voterInfo