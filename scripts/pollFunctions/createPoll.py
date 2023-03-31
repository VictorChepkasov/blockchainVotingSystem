# и другие скрипты (не все добавил) для реализации функционала контракта
from brownie import VotingSystem, accounts

def main():
    createPoll("test2", 14, 124)

def createPoll(title, dateOfStart, dateOfEnd):
    creator = accounts.load('victor')
    deployedContract = VotingSystem[-1]

    poll = deployedContract.createPoll(title, dateOfStart, dateOfEnd,
                                       {'from': creator, 'priority_fee': '1 wei'})

    return poll