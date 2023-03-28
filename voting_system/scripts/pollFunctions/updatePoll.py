from brownie import VotingSystem, accounts

def main():
    updatePoll("TEST_updatePoll", 10, 30, 1)

def updatePoll(title, dateOfStart, dateOfEnd, pollId):
    print(title, dateOfStart, dateOfEnd, pollId)
    creator = accounts.load('victor')
    VotingSystem[-1].updatePoll(title, dateOfStart, dateOfEnd, pollId, {'from': creator, 'priority_fee': '1 wei'})