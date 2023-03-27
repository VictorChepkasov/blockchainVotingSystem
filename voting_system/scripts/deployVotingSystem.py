from brownie import VotingFactory, accounts
from dotenv import load_dotenv
from brownie.network.contract import Contract

load_dotenv()

def main():
    deployVotingSystem()
    print(f'deployed success! Deployed: {deployedContract}')

def deployVotingSystem():
    account = accounts.load('victor')
    print('create factory var')
    factory = VotingFactory[-1]

    votingContract = factory.createNewVoting('testNonFactory', 0, 1, {'from': account, 'priority_fee': '1 wei'})

    print(f'votingSystem contract deployed at {votingContract}, type: {type(votingContract)}')

    return votingContract

# def counter():
