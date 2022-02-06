from brownie import accounts, config, network, MockV3Aggregator
from web3 import Web3

DECIMALS = 18
INITIALANSWER = 200000000000

FORKED_ENVS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_DEVELOPMENT_ENVS = ["development", "Ganache-local"]


def get_account():
    if (
        network.show_active() in LOCAL_DEVELOPMENT_ENVS
        or network.show_active() in FORKED_ENVS
    ):
        return accounts[0]
    else:
        return accounts.add(config["Wallets"]["from_key"])


def deploy_mock():
    print("======================================")
    print(f"active network is {network.show_active()}")
    print("Deploying MOCKS.....!!")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            DECIMALS,  # Parameter that constructor takes this is _decimals
            INITIALANSWER,  # Parameter that constructor takes _initialAnswer
            {"from": get_account()},  # since it is state change type
        )

    print("mock deployed")
