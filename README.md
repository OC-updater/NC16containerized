# NC16containerized
Nextcloud V16 on DEB9 with NginX building into a dockerized container
With two other container { redis, mariadb } running in the backend. Both container have been copypasted from 
https://www.github.com/bitnami/bitnami-docker-redis
https://www.github.com/bitnami/bitnami-docker-mariadb

For Firewall example:
sudo nft list ruleset -a
sudo nft replace rule ip nat PREROUTING handle 8 ip daddr 213.235.249.86 tcp dport { http, https} dnat to 172.17.0.4
sudo nft replace rule ip nat PREROUTING handle 9 ip daddr 192.168.21.100 tcp dport { http, https} dnat to 172.17.0.4
sudo nft list ruleset -a

