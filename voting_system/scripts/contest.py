from brownie import VotingSystem, accounts

def main():
    contest(0)

def contest(pollId):
    contestant = accounts.load('victor')
    deployedContract = VotingSystem[-1]
    deployedContract.contest(pollId, {'from': contestant, 'priority_fee': '1 wei'})
    print("You're now a contestant")