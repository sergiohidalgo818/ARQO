cat /proc/cpuinfo >> cpuinfo.txt
sudo dmidecode >> demicode.txt
sudo getconf -a | grep -i cache >> cache.txt
lstopo lstopo.pdf

