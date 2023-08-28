from brownie import VotingSystem, Poll, Voter

def _params(_from):
    return {
        'from': _from,
        'priority_fee': '10 wei'
    }

def getPoll(_from, _pollId):
    poll = VotingSystem[-1].getPoll(_pollId, _params(_from))
    print('Get poll!')
    return Poll.at(poll)

def getVoter(_from, _voterId):
    voter = VotingSystem[-1].getVoter(_voterId, _params(_from))
    print('Get voter!')
    return Voter.at(voter)

def createVoter(_from):
    voterId = VotingSystem[-1].createVoter(_params(_from)).return_value
    print(f'Voter created! Voter id: {voterId}')
    return voterId

def createPoll(_from, _title):
    pollId = VotingSystem[-1].createPoll(_title, _params(_from)).return_value
    print(f'Poll created! Poll id: {pollId}')
    return pollId