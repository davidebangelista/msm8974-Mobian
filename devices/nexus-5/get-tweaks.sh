cd &&
wget https://gitlab.com/iih09276/nexus-5-repo/-/raw/main/rootfs.7z && cd / &&
7z x /root/rootfs.7z -y && cd && uname -r &&
./setup.sh
