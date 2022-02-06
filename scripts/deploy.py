from brownie import accounts, config, FundMe, network, MockV3Aggregator, web3
from scripts.helphul_scripts import get_account, deploy_mock, LOCAL_DEVELOPMENT_ENVS,FORKED_ENVS


def deploy_fund_me():
    account = get_account()
    # if we r on persistent network use this address
    if network.show_active() not in FORKED_ENVS :

        """way1:not efficient
        fund_me = FundMe.deploy("0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",{"from": account}, publish_source=True)

        way2:not efficient either
        price_feed_address="0x8A753747A1Fa494EC906cE90E9f37563A8AF630e"


        "way3 most efficient :parameterize by adding it in congig file for diffrent networks and
        fetch it from there"""
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]

    # else use mocks or development address
    else:
        deploy_mock()
        price_feed_address = MockV3Aggregator[-1].address
        print("mock deployed")
        print("======================================")

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    """ 
    publish_source=true so that we can see and interact with contract on etherscan.io and 
    the contract contents are verefied by us with help of the API id we have generated and pasted in our dot env file"""
    print(f"Contract is deployed to {fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()
