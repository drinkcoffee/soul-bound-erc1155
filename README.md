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
* `BLOCKSCOUT_APIKEY`: Go to `https://explorer.immutable.com/`, login, and generate an API key. A separate API key is needed for mainnet and testnet.
* Use either a hardware wallet or a private key to deploy the contract. The overall process is simpler if a private key is used. 
  * If using a hardware wallet set:
    * `HARDWARE_WALLET`: Set to `ledger` for Ledger hardware wallet, or `trezor` for a Trezor hardware wallet.
    * `HD_PATH`: Set to the hardware path to be used. For example, `m/44'/60'/0'/0`.
  * If using a private key:
    * `PRIVATE_KEY`: Set the private key to the private. For example, `12345678123456781234567812345678abcdef12345678abcdef12345678abcd`.
* `OWNER`: The account that has the right to administer the contract. Ideally, this would be a Ledger hardware wallet.

Update variables in ExampleERC1155Soulbound.s.sol:

* `baseURI`: URI to be used for all NFTs. For example, `https://drinkcoffee.github.io/projects/erc1155nfts/{id}.json`.
* `contractURI`: URI of collection metadata. For example, `https://drinkcoffee.github.io/projects/erc1155nfts/sample-collection.json`.
* `name`: Name of the collection. For example, `ERC1155 Soulbound Sample Collection`.
* `symbol`: Symbol of the collection. For example, `SBD`.

Execute the deployment script:

```
sh script/deploy.sh
```

If the contract verification times out, change the `common.sh` script to add the ` --resume \ ` line to resume the failed script. Rerun the script and then remove the ` --resume \ ` line.

Note the address of the deployed contract. Go to the block explorer to verify that the contract has been deployed correctly.

## Step 3 Grant Minting API minter role.

Grant the Immutable Minting API the minter role. This is needed to allow the Minting API to mint NFTs.

Add the following to the `.env` file: 

* `NFTCONTRACT`: The address of the deployed contract.

Execute the script:

```
sh script/grantMinterRole.sh
```

## Step 4 Link the contract on Hub

Go to Immutable Hub, [https://hub.immutable.com/](https://hub.immutable.com/), and link the contract. Linking the contract allows the minting API to use the contract and allows a game associate with the Immutable Hub account to use the contract. 

To link the contract: 

* Choose the address that was the owner in step 2 as the account in Hub.
* Choose `Add Project`, and choose `Testnet` or `Mainnet`.
* In the `Contracts` section, choose `Link contract`, and enter the deployed address.

The contract should now be able to used for minting.

## Step 5 Minting

To use the minting API follow the steps below. The minting API documentation has more information: https://docs.immutable.com/api/zkevm/reference/#/operations/GetMintRequest .

Update the NFT metadata in `mintNFTs.sh`. This must match the metadata specified in step 1.

Go to Immutable Hub, within the project, go to the `Keys` section, create an secret API Key. 

Configure environment variables:

* `IMMUTABLEAPIKEY`: The API key.
* `NEWOWNER`: The address to own the NFT once minted.

Run the script:
```
sh script/mintNFTs.sh
```

Once the minting API has been executed, the NFT should be viewable on the block explorer. For example, https://explorer.testnet.immutable.com/token/0xE4BA4Be83C2f92A84CaD66E53E1ea4BBdBED0Cc4 .


## Step 6 Determining Who Owns What

Use this API to fetch which addresses own which tokens:

```
https://api.immutable.com/v1/chains/imtbl-zkevm-mainnet/accounts/{accountAddress}/nfts?contract_address={contractAddress}
```


# Build

```shell
$ forge build
```

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# Dependencies

The following dependencies have been installed in this repo.

forge install immutable/contracts --no-commit
