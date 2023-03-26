from brownie import VotingSystem, accounts

account = accounts.load('victor')

def main():
    firstDeploy()

def firstDeploy():
    deployedContract = VotingSystem.deploy('test', 1, 4, 555, {'from': account, 'priority_fee': '1 wei'})
    return deployedContract