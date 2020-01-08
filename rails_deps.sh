#!/bin/bash
set -ex

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev

# Setup ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
~/.rbenv/bin/rbenv install 2.6.3
~/.rbenv/bin/rbenv global 2.6.3
~/.rbenv/bin/rbenv rehash
ls -al ~/.rbenv/bin
# PATH="$HOME/.rbenv/bin:$PATH"
source ~/.bashrc
eval "$(rbenv init -)"
# gem install bundler

# # Setup node
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
# echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
# echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
# source ~/.bashrc
# nvm install 8.16.0

# # Setup yarn
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# sudo apt-get install --no-install-recommends -y yarn

# # Test dependencies
# sudo apt-get install -y redis-server libmysqlclient-dev chromium-chromedriver firefox-geckodriver

# # Cleanup
# rm -rf /var/lib/apt/lists/*
