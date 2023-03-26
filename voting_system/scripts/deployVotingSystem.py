from brownie import VotingSystem, VotingFactory, accounts
from dotenv import load_dotenv
from brownie.network.contract import Contract

load_dotenv()

def main():
    deployVotingSystem()
    # getPoll()
    print('deployed success!')

def deployVotingSystem():
    account = accounts.load('victor')
    print('create factory var')
    factory = VotingFactory[-1]

    votingContract = factory.createNewVoting.call('test2', 1, 4, {'from': account, '':2, 'priority_fee': '1 wei'})
    
    print(f'votingSystem contract deployed at {votingContract}, type: {type(votingContract)}')

    return votingContract