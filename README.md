# IBC Testing with Local Chains

## Build Docker images

Clone the repo and run the following command to build agoric chain image.

```
$ docker build -t a3p:local .
```

## Start the network

The following command starts the network with two agoric chains and a relayer.

```
$ docker-compose up -d
```

## Transfer some token

Make sure that chains are up and running, and the relayer is initialized. The following command should say that the hermes relayer has started:

```
$ docker logs -f relayer
```

The chains are set up with pre-existing accounts that are already funded with tokens. To inspect the token balances of these accounts, open a new terminal window and execute the following commands:

```
$ docker exec agoric-local-1 agd query bank balances agoric1myfpdaxyj34lqexe9cypu6vrf34xemtfq2a0nt
$ docker exec agoric-local-2 agd query bank balances agoric1aczzle80960fc0vq8gemjuu8ydrql07az7fmur
```

For conducting an IBC (Inter-Blockchain Communication) transaction using the relayer, use the following command:

```
$ docker exec relayer hermes --config /workspace/relayer/config.toml tx ft-transfer --src-chain agoric-local-1 --src-channel channel-0 \
 --dst-chain agoric-local-2 --src-port transfer --amount 100 --denom 'ubld' --timeout-seconds 1000
```

After completing the transaction, you should verify the account balances again to confirm the transfer.

# IBC Testing with Emerynet and Devnet

## Start the relayer

The following command starts the network with two agoric chains and a relayer.

```
$ docker-compose -f docker-compose-testnet.yaml up -d
```

## Transfer IBC tokens

Get the new channel ID got created from the relayer logs.
```
docker logs relayer
```
Use the new channel ID in the following command to transfer tokens from Emerynet to Devnet using IBC relayer.

```
$ docker exec relayer hermes --config /workspace/relayer/config-testnet.toml tx ft-transfer --src-chain agoric-emerynet-8 --src-channel <Channel-ID> \
 --dst-chain agoricdev-23 --src-port transfer --amount 100 --denom 'ubld' --timeout-seconds 1000
```

Verify the account balances to confirm the transfer for both Emerynet and Devnet. 

On devnet
```
agd query bank balances agoric1khw65emzav9t0cdhj3aw9x2v7m60jekjdf4whl
```

On emerynet
```
agd query bank balances agoric10emrzln03exuc9uv98mjwmp95735mjm6k2n9xm
```
