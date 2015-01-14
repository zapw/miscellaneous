include ../../../../../Teams.mk

C_SOURCES := \
./api/api_lib.c \
./api/api_msg.c \
./api/err.c \
./api/netbuf.c \
./api/netifapi.c \
./api/sockets.c \
./api/tcpip.c \
./core/dhcp.c \
./core/init.c \
./core/mem.c \
./core/memp.c \
./core/netif.c \
./core/pbuf.c \
./core/raw.c \
./core/stats.c \
./core/udp.c \
./core/sys.c \
./core/tcp.c \
./core/tcp_in.c \
./core/tcp_out.c \
./core/timers.c \
./core/def.c \
./core/ipv4/autoip.c \
./core/ipv4/icmp.c \
./core/ipv4/igmp.c \
./core/ipv4/inet.c \
./core/ipv4/ip.c \
./core/ipv4/ip_addr.c \
./core/ipv4/ip_frag.c \
./core/ipv4/inet_chksum.c \
./core/ipv6/dhcp6.c \
./core/ipv6/icmp6.c \
./core/ipv6/mld6.c \
./core/ipv6/nd6.c \
./core/ipv6/inet6.c \
./core/ipv6/ip6.c \
./core/ipv6/ip6_addr.c \
./core/ipv6/ip6_frag.c \
./core/ipv6/ip6_chksum.c \
./core/snmp/asn1_dec.c \
./core/snmp/asn1_enc.c \
./core/snmp/mib2.c \
./core/snmp/mib_structs.c \
./core/snmp/msg_in.c \
./core/snmp/msg_out.c \
./netif/etharp.c \
./netif/ethip6.c \
./sys_arch.c

sources := $(C_SOURCES)
LWIP_OBJS := $(C_SOURCES:%.c=%.o)

INC_DIR_LOCAL := ./include/ 
INC_DIR_IPv4  := ./include/ipv4
INC_DIR_IPv6  := ./include/ipv6

CC := g++
CFLAGS := -g -fPIC -w
all_lib_inc := -I$(INC_DIR_LOCAL) -I$(INC_DIR_IPv4) -I$(INC_DIR_IPv6)
CPPFLAGS := $(all_lib_inc)

.PHONY: default
default: $(LWIP_OBJS)

clean:
	rm -f $(LWIP_OBJS) .*.d $(includes)

$(eval $(auto_prerequisite_gen))
