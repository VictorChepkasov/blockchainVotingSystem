from brownie import Voter
from .VotingSystemFunctions import _params

def getVoterInfo(_from, voter):
    voterInfo = voter.getVoterInfo(_params(_from))
    print(f'Voter info: {voterInfo}')
    return voterInfo

def joinPoll(_from, voter, poll):
    voter.joinPoll(poll, _params(_from))
    print('Voter joined!')

def setInviteContestant(_from, voter, poll):
    voter.setInviteContestant(poll, _params(_from))
    print('Invite saved, add new contestant!')

def vote(_from, contestantId, voter, poll):
    voter.vote(poll, contestantId, _params(_from))
    print(f'Voter voted for contestant id:{contestantId}')