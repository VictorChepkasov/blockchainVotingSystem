from brownie import VotingSystem, Poll, Voter, accounts
from dotenv import load_dotenv

load_dotenv()

def main():
    deployVotingSystem(accounts[0])

def deployVotingSystem(_from):
    pollMasterContract = Poll.deploy({
        'from': _from,
        'priority_fee': '10 wei'
    })
    print(f'Poll master-contract deployed successful!')

    voterMasterContract = Voter.deploy({
        'from': _from,
        'priority_fee': '10 wei'
    })
    print(f'Voter master-contract deployed successful!')

    deployedVotingSystem = VotingSystem.deploy(pollMasterContract, voterMasterContract, {
        'from': _from,
        'priority_fee': '10 wei'
    })
    print(f'Voting system deployed successful!')
    
    return deployedVotingSystem