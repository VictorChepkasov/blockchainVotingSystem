from brownie import VotingFactory, accounts
from dotenv import load_dotenv

load_dotenv()
account = accounts.load('victor')

def main():
    deployVotingFactory()
    print('deployed success!')

def deployVotingFactory():
    votingFactory = VotingFactory.deploy({'from': account, 'priority_fee': '1 wei'})

    print(f'contract factory deployed at: {votingFactory}')

    return votingFactory