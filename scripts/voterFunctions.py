from .votingSystemFunctions import _params

class Voter:
    def __init__(self, _voter):
        self.voter = _voter
        self.voterAddress = _voter.getVoterInfo()[0]

    def getVoterInfo(self):
        voterInfo = self.voter.getVoterInfo(_params(self.voterAddress))
        print(f'Voter info: {voterInfo}')
        return voterInfo

    def joinPoll(self, poll):
        self.voter.joinPoll(poll, _params(self.voterAddress))
        print('Voter joined!')

    def setInviteContestant(self, poll):
        self.voter.setInviteContestant(poll, _params(self.voterAddress))
        print('Invite saved, add new contestant!')

    def vote(self, contestantId, poll):
        self.voter.vote(poll, contestantId, _params(self.voterAddress))
        print(f'Voter voted for contestant id:{contestantId}')

    def deleteVoter(self):
        self.voter.deleteVoter(_params(self.voterAddress))
        print('Voter deleted!')