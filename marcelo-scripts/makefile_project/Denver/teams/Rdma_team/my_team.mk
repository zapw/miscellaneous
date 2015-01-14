ADAPTERS := IPs/Eth/Rdma IPs/Eth/Generic
EXTRA_TEAM_INC := -I$(team_dir)/infrastructure/generic/lwip/include -I$(team_dir)/infrastructure/generic/lwip/include/ipv4 -I$(team_dir)/infrastructure/generic/lwip/include/ipv6 -I$(team_dir)/infrastructure/generic/SoftRDMA -I/usr/include/mysql -I/usr/include/mysql++ -I/usr/include/services/Anue -I$(team_dir)/infrastructure/generic/lwip/include/lwip -I$(team_dir)/infrastructure/generic/lwip/include/ipv4  -I$(team_dir)/infrastructure/generic/lwip/include/arch
EXTRA_TEAM_LIB = -lssl -lcrypto -lmysqlpp -lAnue -lpthread
