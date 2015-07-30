#!/bin/bash

mkdir ~/Builds/intellij && cd ~/Builds/intellij
wget -O idea.tar.gz https://download.jetbrains.com/idea/ideaIU-14.1.4.tar.gz
echo '5c6dfb5ba9f2c3294ee125e96e96e50287a460784287181a8e83e4326005bac3 idea.tar.gz' | sha256sum --status --check -
tar xzf idea.tar.gz && mv idea-*/* . && rm -f idea.tar.gz
sudo ln -s "$(pwd)/bin/idea.sh" /usr/bin/intellij
