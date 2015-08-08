#!/bin/bash -xe

sudo apt-get -y install i3lock
echo -e '#!/bin/bash\ni3lock -c 000000' \
	| sudo tee /usr/local/bin/lock
sudo chmod a+x /usr/local/bin/lock
