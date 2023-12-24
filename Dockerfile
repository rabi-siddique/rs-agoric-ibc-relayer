FROM --platform=linux/amd64 ghcr.io/agoric/agoric-3-proposals:main

RUN mkdir -p /root/.agoric/export
RUN agd export --home /root/.agoric --export-dir /root/.agoric/export

RUN mv /root/.agoric/data/priv_validator_state.json /root/.agoric/priv_validator_state.json
RUN rm -rf /root/.agoric/data/*
RUN mv /root/.agoric/priv_validator_state.json /root/.agoric/data/priv_validator_state.json
RUN rm /root/.agoric/config/genesis.json
RUN rm -rf /root/.agoric/config/swing-store
RUN mv /root/.agoric/export/* /root/.agoric/config/

WORKDIR /usr/src/upgrade-test-scripts
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ./start_agd.sh
