# GitHub's Linux runners default to the latest Ubunutu
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners#supported-runners-and-hardware-resources
# Ubuntu uses the latest tag to represent the latest stable release
# https://hub.docker.com/_/ubuntu/
# FROM ubuntu:latest
FROM ruby:2.6.3

# Add our installation script
COPY install.sh /root/

# Install and update the system in one tidy layer
ARG ACTIONS_RUNNER_VERSION="2.164.0"
ENV ACTIONS_RUNNER_VERSION=$ACTIONS_RUNNER_VERSION
RUN /bin/bash /root/install.sh

# Run as the runner user instead of root
USER runner
WORKDIR /home/runner
COPY *.sh ./
# RUN /bin/bash ./rails_deps.sh

RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev

# Setup ruby
# RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
# RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# RUN ~/.rbenv/bin/rbenv install 2.6.3
# RUN ~/.rbenv/bin/rbenv global 2.6.3
# RUN ~/.rbenv/bin/rbenv rehash
# RUN ls -al ~/.rbenv/bin
# # PATH="$HOME/.rbenv/bin:$PATH"
# RUN source ~/.bashrc
# RUN eval "$(rbenv init -)"
# RUN gem install bundler

# # Set the SHELL to bash with pipefail option
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup node
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - && \
  DISTRO="$(lsb_release -s -c)" && \
  NODE_VERSION=node_8.x && \
  echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list && \
  sudo apt-get update && \
  sudo apt-get install -y nodejs

# RUN mkdir /home/runner/.nvm
# ENV NVM_DIR=/home/runner/.nvm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
# RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
# # RUN source $NVM_DIR/.nvm.sh
# RUN nvm install 8.16.0

# Setup yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y yarn

# Firefox driver
RUN sudo apt-get install -y firefox-esr
RUN curl -LO https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
RUN tar xvzf geckodriver*
RUN chmod 755 geckodriver
RUN sudo mv geckodriver /usr/local/bin

# Chrome driver
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN sudo apt-get -y update
RUN sudo apt-get -y install google-chrome-stable
RUN curl -OL https://chromedriver.storage.googleapis.com/80.0.3987.16/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN sudo mv chromedriver /usr/bin/chromedriver
RUN sudo chown root:root /usr/bin/chromedriver
RUN sudo chmod +x /usr/bin/chromedriver

# Test dependencies
RUN sudo apt-get install -y redis-server

RUN /bin/bash ./test.sh
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]
