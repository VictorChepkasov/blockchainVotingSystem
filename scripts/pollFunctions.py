from .votingSystemFunctions import _params

class Poll:
    def __init__(self, _poll):
        self.poll = _poll
        self.pollCreatorAddress = _poll.getPollInfo()[0]

    def getPollInfo(self):
        pollInfo = self.poll.getPollInfo()
        print(f'Poll info: {pollInfo}')
        return pollInfo

    def getContestant(self, _contestantId):
        contestantAddress = self.poll.getContestant(_contestantId)
        print(f'Contestant address: {contestantAddress}')
        return contestantAddress

    def getVoter(self, _voterId):
        voterAddress = self.poll.getVoter(_voterId)
        print(f'Voter address: {voterAddress}')
        return voterAddress

    def inviteContestant(self, _contestantId):
        self.poll.inviteContestant(_contestantId, _params(self.pollCreatorAddress))
        print(f'{_contestantId} invited!')

    def updateTitle(self, _title):
        self.poll.updateTitle(_title, _params(self.pollCreatorAddress))
        print('Poll title updated!')

    def startContest(self, _dateOfEnd):
        self.poll.startContest(_dateOfEnd, _params(self.pollCreatorAddress))
        print(f'Voting start! End: {_dateOfEnd}')

    def endContest(self):
        winnerAddress = self.poll.endContest(_params(self.pollCreatorAddress)).return_value
        print(f'Vinner: {winnerAddress}')
        return winnerAddress

    def deletePoll(self):
        self.poll.deletePoll(_params(self.pollCreatorAddress))
        print('Poll deleted!')