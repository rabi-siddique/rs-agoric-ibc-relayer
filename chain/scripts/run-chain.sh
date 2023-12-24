#!/bin/bash

wait_for_bootstrap() {
  endpoint="localhost"
  while true; do
    if json=$(curl -s --fail -m 15 "$endpoint:26657/status"); then
      if [[ "$(echo "$json" | jq -r .jsonrpc)" == "2.0" ]]; then
        if last_height=$(echo "$json" | jq -r .result.sync_info.latest_block_height); then
          if [[ "$last_height" != "1" ]]; then
            echo "$last_height"
            return
          else
            echo "$last_height"
          fi
        fi
      fi
    fi
    echo "waiting for next block..."
    sleep 5
  done
  echo "done"
}

waitForBlock() (
  echo "waiting for block..."
  times=${1:-1}
  echo "$times"
  for ((i = 1; i <= times; i++)); do
    b1=$(wait_for_bootstrap)
    while true; do
      b2=$(wait_for_bootstrap)
      if [[ "$b1" != "$b2" ]]; then
        echo "block produced"
        break
      fi
      sleep 5
    done
  done
  echo "done"
)

export AGORIC_HOME=$HOME/.agoric

sed -i "s/agoriclocal/$CHAIN_ID/" /usr/src/upgrade-test-scripts/env_setup.sh
sed -i "s/agoriclocal/$CHAIN_ID/" $AGORIC_HOME/config/genesis.json
sed -i 's/^snapshot-interval = .*/snapshot-interval = 0/' $AGORIC_HOME/config/app.toml

agd start --log_level warn --home $AGORIC_HOME &

waitForBlock 5

agd tx bank send validator agoric1myfpdaxyj34lqexe9cypu6vrf34xemtfq2a0nt 500000000ubld --keyring-backend=test --chain-id="$CHAIN_ID" \
		--gas=auto --gas-adjustment=1.2 \
		--yes -b block

agd tx bank send validator agoric1aczzle80960fc0vq8gemjuu8ydrql07az7fmur 500000000ubld --keyring-backend=test --chain-id="$CHAIN_ID" \
		--gas=auto --gas-adjustment=1.2 \
		--yes -b block

touch "/state/$CHAIN_ID"
wait
