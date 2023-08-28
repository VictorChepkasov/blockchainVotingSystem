from .VotingSystemFunctions import _params

def getPollInfo(_from, poll):
    pollInfo = poll.getPollInfo(_params(_from))
    print(f'Poll info: {pollInfo}')
    return pollInfo

def getContestant(_from, _contestantId, poll):
    contestantAddress = poll.getContestant(_contestantId, _params(_from))
    print(f'Contestant address: {contestantAddress}')
    return contestantAddress

def getVoter(_from, _voterId, poll):
    voterAddress = poll.getVoter(_voterId, _params(_from))
    print(f'Voter address: {voterAddress}')
    return voterAddress

def inviteContestant(_from, _contestantId, poll):
    poll.inviteContestant(_contestantId, _params(_from))
    print(f'{_contestantId} invited!')

def updateTitle(_from, _title, poll):
    poll.updateTitle(_title, _params(_from))
    print('Poll title updated!')

def startContest(_from, _dateOfEnd, poll):
    poll.startContest(_dateOfEnd, _params(_from))
    print(f'Voting start! End: {_dateOfEnd}')

def endContest(_from, poll):
    winnerAddress = poll.endContest(_params(_from))
    print(f'Vinner: {winnerAddress}')
    return winnerAddress

def deletePoll(_from, poll):
    poll.deletePoll(_params(_from))
    print('Poll deleted!')