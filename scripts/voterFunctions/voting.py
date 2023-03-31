from brownie import VotingSystem, accounts

def main():
    vote(0, 0)

def vote(pollId, contestantId):
    voter = accounts.load('victor')
    deployedContract = VotingSystem[-1]
    deployedContract.vote(pollId, contestantId, {'from': voter, 'priority_fee': '1 wei'})
    print('Vote successful')