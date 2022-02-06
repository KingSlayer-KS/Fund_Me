from brownie import FundMe,network,config,accounts
from scripts.helphul_scripts import get_account
from scripts.deploy import deploy_fund_me
from web3 import Web3

def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getEntranceFee()
    print(entrance_fee)
    print(f"The current entry fee is {entrance_fee}")
    print("Hang in there Funding.....")
    fund_me.Fund({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})

    
def main():
      fund()
      withdraw()
