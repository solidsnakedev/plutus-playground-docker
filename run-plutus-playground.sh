#!/bin/bash
#cd /home/cardano/plutus-apps
nix-shell --run "cd plutus-playground-server && plutus-playground-server" &
#nix-shell --run "build-and-serve-docs" &
nix-shell --run "cd plutus-playground-client && npm start"