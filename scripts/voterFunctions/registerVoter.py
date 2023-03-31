from brownie import VotingSystem, accounts

def main():
    registerVoter()

def registerVoter():
    creator = accounts[0]
    # deployedContract = VotingSystem[-1]
    deployedContract = VotingSystem.deploy({'from': creator, 'priority_fee': '1 wei'})

    voter = deployedContract.registerVoter({'from': creator, 'priority_fee': '1 wei'})
    print(f'Register voter finish!')

    return voter