from brownie import VotingFactory, VotingSystem, accounts
from dotenv import load_dotenv

load_dotenv()
account = accounts.load('victor')

def main():
    deloy_voting_factory()
    print('deployed success!')

def deloy_voting_factory():
    voting_factory = VotingFactory.deploy(VotingSystem[-1], {'from': account, 'priority_fee': '1 wei'})

    print(f'''
    contract deployed at: {voting_factory}
    last deployed voting_system contract: {VotingSystem[-1]}
    ''')

    return voting_factory