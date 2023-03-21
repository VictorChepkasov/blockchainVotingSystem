from brownie import VotingSystem, accounts
from dotenv import load_dotenv

load_dotenv()
account = accounts.load('victor')

def main():
    deploy_voting_system()
    print('deployed success!')

def deploy_voting_system():
    voting_contract = VotingSystem.deploy('test', '1', '4', '1', {'from': account, 'priority_fee': '1 wei'})
    print(f'contract deployed at {voting_contract}') 

    for i in range(0, len(VotingSystem)):
        print(f'{i}: {VotingSystem[i]}')
    return voting_contract