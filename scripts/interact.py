import os
from brownie import Contract, accounts
from dotenv import load_dotenv
load_dotenv()

def main():
    account = accounts.add(os.getenv("PRIVATE_KEY"))
    usdc_contract = Contract('0x740eEe371a712C8b0c51F9aD48fcc941386A158A')
    defi_contract = Contract('0xF829451719e7d0Db07388e15b8Bc1AC017E33b79')
    
    print(f"Before function call Current usdc token deposit balance is {defi_contract.depositBalance(account)}")
    usdc_contract.approve(defi_contract, 10000, {"from": account})
    defi_contract.depositToken(10000, {"from": account})

    print(f"After function call Current usdc token deposit balance is {defi_contract.depositBalance(account)}")
    
    defi_contract.withdraw(100, {"from": account})
    

    print(f"Current balance after Withdraw usdc token deposit balance is {defi_contract.depositBalance(account)}")
