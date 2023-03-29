from brownie import VotingSystem, accounts

def main():
    deletePoll(0)

def deletePoll(pollId):
    creator = accounts.load('victor')
    deployedContract = VotingSystem[-1]
    deployedContract.deletePoll(pollId, {'from': creator, 'priority_fee': '1 wei'})
