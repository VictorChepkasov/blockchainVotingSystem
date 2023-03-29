from brownie import VotingSystem, accounts

def main():
    getAllPolls()

def getAllPolls():
    deployedContract = VotingSystem[-1]
    polls = list(deployedContract.getAllPolls())

    if len(polls) == 0:
        print("There are no polls :(")
    else: 
        for i in range(len(polls)):
            print(f'{i+1}: {polls[i]}')
    
    return polls