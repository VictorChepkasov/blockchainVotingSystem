from brownie import VotingSystem, accounts

def main():
    listContestants(1)

def listContestants(contestantId):
    deployedContract = VotingSystem[-1]
    listContestants = deployedContract.listContestants(contestantId)
    print(f'list contestants: {listContestants}')

    return listContestants