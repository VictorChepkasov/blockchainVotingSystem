from brownie import VotingSystem

def main():
    getPoll()

def getPoll():
    # for i in range(0, len(VotingSystem)):
    #     print(f'{i}: {VotingSystem[i]}')

    votingContract = VotingSystem[-1]
    contractInfo = votingContract.getPoll()
    print(contractInfo)

    contratcId = contractInfo[2]

    print(f'contratc id: {contratcId}')
    return contractInfo