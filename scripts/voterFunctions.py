from brownie import Voter
from .VotingSystemFunctions import _params

def getVoterInfo(_from, voter):
    voterInfo = voter.getVoterInfo(_params(_from))
    print(f'Voter info: {voterInfo}')
    return voterInfo

def setInviteContestant(_from, voter, poll):
    voter.setInviteContestant(poll, _params(_from))

