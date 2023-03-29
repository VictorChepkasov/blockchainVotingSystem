from brownie import VotingSystem, accounts

def main():
    registerVoter()

def registerVoter():
    creator = accounts.load('victor')
    deployedContract = VotingSystem[-1]

    voter = deployedContract.registerVoter({'from': creator, 'priority_fee': '1 wei'})
    print('Register voter finish!')

    return voter