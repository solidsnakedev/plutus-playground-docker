FROM ubuntu:rolling
# Install dependencies
RUN apt-get update -y
RUN apt-get install wget git curl tar xz-utils sudo build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 -y
#create the user's home directory and login shell of the new account
RUN useradd -m -s /bin/bash cardano
#append the user to the supplemental GROUPS and new list of supplementary GROUPS
RUN usermod -a -G sudo cardano
#Update user passsword 
#RUN /bin/bash -c "echo "cardano:cardano" | chpasswd"
#Disable password when using sudo
RUN echo "cardano  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /etc/nix
RUN touch /etc/nix/nix.conf
RUN echo "substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/" >> /etc/nix/nix.conf && \
    echo "trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" >> /etc/nix/nix.conf && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

RUN mkdir /home/cardano/projects && \
    chown -R cardano:cardano /home/cardano/projects

USER cardano
ENV USER=cardano
WORKDIR /home/cardano

# Install GHC version 8.10.4 and Cabal
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_MINIMAL=1 sh
ENV PATH="/home/cardano/.cabal/bin:/home/cardano/.ghcup/bin:$PATH"
RUN ghcup upgrade && \
    ghcup install cabal 3.6.2.0 && \
    ghcup set cabal 3.6.2.0 && \
    ghcup install ghc 8.10.7 && \
    ghcup set ghc 8.10.7 && \
    ghcup install hls

# Clone plutus-pioneer-progam
RUN git clone https://github.com/input-output-hk/plutus-pioneer-program.git

# GIT_TAG Variable from docker compose build command
ARG GIT_TAG
# Clone plutus-apps
RUN git clone https://github.com/input-output-hk/plutus-apps.git
# Change workind directory
WORKDIR /home/cardano/plutus-apps
# Checkout to GIT_TAG
RUN git checkout ${GIT_TAG}

# Install Nix
RUN curl -L https://nixos.org/nix/install | sh
# Set binaries path for nix
ENV PATH="/home/cardano/.nix-profile/bin:${PATH}"
# Adding nix bash file
RUN echo ". /home/cardano/.nix-profile/etc/profile.d/nix.sh" >> /home/cardano/.bashrc
# Run nix-shell to compile all the packages
RUN nix-shell

# Exposing the website outside of the container, from localhost to 0.0.0.0
RUN sed -i -e "s/port: 8009/host: '0.0.0.0',\n        port: 8009/g" /home/cardano/plutus-apps/plutus-playground-client/webpack.config.js

# Adding script to run plutus playground
COPY ./run-plutus-playground.sh /bin
RUN sudo /bin/bash -c "chmod +x /bin/run-plutus-playground.sh"

# Run script when launching plutus playground container
CMD ["bash","run-plutus-playground.sh"]