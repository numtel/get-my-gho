# Get My GHO

*I've got GHO on mainnet but no ETH to do anything with it!*

Help me out by swapping it to ETH and I'll give you 0.07 ETH. Deploying and executing the swaps/transfers costs about this much at 50 gwei so wait for low gas to perform transactions to make a profit.

## Installation

```sh
$ git clone https://github.com/numtel/get-my-gho
$ cd get-my-gho
$ forge install
```

> `npm install` is only required to run the frontend signature creator

## Operation


### 0. Dry Run

Test that the script is configured successfully. You will need to supply a valid permit in `.env`.

```sh
$ yarn dryrun
```

### 1. Deploy the contract

```sh
$ cp .env.example .env
$ vim .env
# Update PRIVATE_KEY and ETHERSCAN_API_KEY values
$ yarn deploy

```

Now, tell me the address of the deployed contract. I will check it on Etherscan and send you back the permit for the spend.

### 2. Execute the swapper

```sh
$ vim .env
# Update PERMIT_DEADLINE, PERMIT, and GETMYGHO (contract address) values.
$ yarn execute
```


