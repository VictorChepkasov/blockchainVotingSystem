from brownie import VotingSystem

def main():
    getPoll(0) # посмотрим на данные второго опроса

def getPoll(pollId):
    deployedContract = VotingSystem[-1]
    pollInfo = deployedContract.getPoll(pollId)
    print(pollInfo)
    return pollInfo