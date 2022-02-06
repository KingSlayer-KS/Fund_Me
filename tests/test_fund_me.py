from brownie import accounts, network,exceptions
from scripts.helphul_scripts import get_account,LOCAL_DEVELOPMENT_ENVS,deploy_mock
from scripts.deploy import deploy_fund_me
import pytest


def test_can_fund_and_withdraw():
    account=get_account()
    fund_me= deploy_fund_me()
    entrance_fee=fund_me.getEntranceFee()+100
    tx=fund_me.Fund({"from": account, "value": entrance_fee})
    tx.wait(1)
    assert fund_me.addressToAmountFunded(account.address) == entrance_fee
    tx2 = fund_me.withdraw({"from":account})
    tx2.wait(1)
    assert fund_me.addressToAmountFunded(account.address) == 0

def test_only_owner_can_withdraw():
    if network.show_active() not in LOCAL_DEVELOPMENT_ENVS:
      pytest.skip("only for localtesting")  
    fund_me=deploy_fund_me()
    bad_actor=accounts.add()#adds random account
    with pytest.raises(exceptions.VirtualMachineError):#this meands we want u to return this error
        fund_me.withdraw({"from":bad_actor})



