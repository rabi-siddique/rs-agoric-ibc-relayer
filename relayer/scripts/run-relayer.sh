#!/bin/bash

hermes --config /workspace/relayer/config.toml keys add --chain agoric-local-1 --mnemonic-file /workspace/relayer/keys/alice.key
hermes --config /workspace/relayer/config.toml keys add --chain agoric-local-2 --mnemonic-file /workspace/relayer/keys/bob.key

hermes --config /workspace/relayer/config.toml create channel --a-chain agoric-local-1 --b-chain agoric-local-2 --a-port transfer --b-port transfer --new-client-connection --yes

hermes --config /workspace/relayer/config.toml start
