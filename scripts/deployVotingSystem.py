from brownie import VotingSystem, accounts
from dotenv import load_dotenv
from brownie.network.contract import Contract

load_dotenv()

def main():
    deployedContract = deployVotingSystem()
    print(f'deployed success! Deployed: {deployedContract}')

def deployVotingSystem():
    account = accounts.load('victor')
    votingContract = VotingSystem.deploy({
        'from': account,
        'priority_fee': '1 wei'
    })
    print(f'votingSystem contract deployed at {votingContract}')

    return votingContract