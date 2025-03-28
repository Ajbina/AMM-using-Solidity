# Automatic Market Maker (AMM) 

This project implements an Automatic Market Maker (AMM) in Solidity that allows users to swap between Ether and ERC-20 tokens (ASA, HAW, and KOR tokens), provide liquidity, and withdraw liquidity.

## Project Structure

Exchange.sol: Smart contract for AMM

AsaToken.sol: ERC-20 token (ASA)

HawKoin.sol: ERC-20 token (HAW)

KorthCoin.sol: ERC-20 token (KOR)

## Prerequisites

MetaMask Wallet

Remix IDE (remix.ethereum.org)

Connect to lu-eth network

Solidity Compiler version 0.8.7

### Step 1: Deploy ERC-20 Tokens

Open Remix IDE.

Compile each token contract:

AsaToken.sol

HawKoin.sol

KorthCoin.sol

Deploy each token contract (one by one).

Copy the contract addresses of ASA, HAW, and KOR tokens.

### Step 2: Deploy Exchange Contract for Each Token

Compile Exchange.sol.

Deploy Exchange.sol three times with each token’s address:

For ASA: Exchange(ASA Contract Address)

For HAW: Exchange(HAW Contract Address)

For KOR: Exchange(KOR Contract Address)

Copy the deployed Exchange contract addresses.

### Step 3: Add Tokens to MetaMask

Open MetaMask.

Go to Assets → Import Tokens → Custom Token.

Add the contract addresses for ASA, HAW, and KOR.

### Step 4: Mint ERC-20 Tokens

In Remix, go to AsaToken.sol (Deployed Contract).

Call mintMe(1000) to mint 1000 ASA tokens.

Repeat for HAW and KOR.

### Step 5: Approve Exchange Contract to Spend Tokens

In Remix, go to AsaToken.sol (Deployed Contract).

Call approve(address spender, uint256 amount).

spender = Exchange contract address for ASA.

amount = 10000000000000000000 (10 ASA with 18 decimals).

Repeat for HAW and KOR tokens.

### Step 6: Provide Liquidity

In Remix, go to Exchange.sol (Deployed Contract for ASA).

Call provideLiquidity(uint _amountERC20Token).

_amountERC20Token = 1000000000000000000 (1 ASA).

In the VALUE field (above the function), enter 1000000000000000000 (1 ETH).

Click Transact and confirm in MetaMask.

Repeat for HAW and KOR.

### Step 7: Swap Tokens for ETH

In Remix, go to Exchange.sol (Deployed Contract for ASA).

Call swapForEth(uint _amountERC20Token).

_amountERC20Token = 1000000000000000000 (1 ASA).

Confirm in MetaMask.

### Step 8: Swap ETH for Tokens

In Remix, go to Exchange.sol (Deployed Contract for ASA).

In the VALUE field, enter 500000000000000000 (0.5 ETH).

Call swapForERC20Token().

Confirm in MetaMask.

### Step 9: Withdraw Liquidity

In Remix, go to Exchange.sol (Deployed Contract for ASA).

Call withdrawLiquidity(uint _liquidityPositionsToBurn).

_liquidityPositionsToBurn = 50.

Confirm in MetaMask.

### Step 10: Verify Contract Balances

Call getContractEthBalance() to check ETH balance in the contract.

Call balanceOf(ExchangeContractAddress) on the token contract to check the token balance.

Call getMyLiquidityPositions() to check your liquidity positions.


## Conclusion

This project successfully demonstrates the working of an Automatic Market Maker (AMM). It allows swapping, providing liquidity, and withdrawing liquidity between ETH and ERC-20 tokens.


