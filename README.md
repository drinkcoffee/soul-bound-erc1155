# Soulbound ERC1155 Example

This repo contains an ERC 1155 Soulbound contract that has the following properties:

- NFTs can be minted.
- NFTs can not be transferred.
- NFTS can not be burned.

# Sequence

The following is the sequence of tasks required to set-up an ERC 1155 Soulbound NFT collection.

## Step 1: Deploy NFT Graphics and Metadata to Website

Deploy NFT graphics, (optionally) videos, collection and token json metadata files, as per instructions here: https://docs.immutable.com/products/zkevm/contracts/erc1155/ . For example:

* Collection metadata: https://drinkcoffee.github.io/projects/erc1155nfts/sample-collection.json
* Token id 100 metadata: https://drinkcoffee.github.io/projects/erc1155nfts/0000000000000000000000000000000000000000000000000000000000000064.json

## Step 2: Deploy the ERC 1155 Soulbound Contract

Set-up the following environment variables in the `.env` file:

* `IMMUTABLE_NETWORK`: Set to 1 for Mainnet, 0 (or any other value) for Testnet.
*

* Deploy contract. Note you will need to set-up environment variables.
```
sh script/deploy.sh
```
* Grant Minting API minter role. 
```
sh script/grantMinterRole.sh
```
* Link the contract on Hub.
* If you haven't already, generate an Immutable API key for the project. For Immutable Hub and the minting API, this is project specific.
* Mint some NFTs. 
```
sh script/mintNFTs.sh
```




## Usage

### Build

```shell
$ forge build
```

### Deploy

Not that `script/deploy.sh` needs small modifications to switch between mainnet and testnet. It also has instructions if deploying using a Ledger hardware wallet.

```shell
$ export PKEY=<your key>
$ export APIKEY=<your blockscout test net or mainnet API key>
$ sh script/deploy.sh
```



### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


The following dependencies have been installed.

forge install immutable/contracts --no-commit
