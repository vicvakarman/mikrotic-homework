# nov/24/2022 12:19:47 by RouterOS 6.48.6
# software id = 041D-YP8G
#
# model = 750
# serial number = 25B901A00A36
/interface bridge
add name=bridge1
/interface ethernet
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
/interface list
add name=WAN
add name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp ranges=10.10.0.10-10.10.0.254
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge1 name=dhcp1
/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 disabled=yes interface=ether4
add bridge=bridge1 disabled=yes interface=ether5
/interface list member
add interface=ether1 list=WAN
add interface=bridge1 list=LAN
/ip address
add address=10.10.0.1/24 interface=bridge1 network=10.10.0.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=10.10.0.0/24 gateway=10.10.0.1 netmask=24
/ip firewall address-list
add address=10.10.0.10-10.10.0.254 list=allowed_to_router
add address=0.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=172.16.0.0/12 comment=RFC6890 list=not_in_internet
add address=192.168.0.0/16 comment=RFC6890 list=not_in_internet
add address=10.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=169.254.0.0/16 comment=RFC6890 list=not_in_internet
add address=127.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=224.0.0.0/4 comment=Multicast list=not_in_internet
add address=198.18.0.0/15 comment=RFC6890 list=not_in_internet
add address=192.0.0.0/24 comment=RFC6890 list=not_in_internet
add address=192.0.2.0/24 comment=RFC6890 list=not_in_internet
add address=198.51.100.0/24 comment=RFC6890 list=not_in_internet
add address=203.0.113.0/24 comment=RFC6890 list=not_in_internet
add address=100.64.0.0/10 comment=RFC6890 list=not_in_internet
add address=240.0.0.0/4 comment=RFC6890 list=not_in_internet
add address=192.88.99.0/24 comment="6to4 relay Anycast [RFC 3068]" list=\
    not_in_internet
/ip firewall filter
add action=accept chain=input connection-state=established,related
add action=accept chain=input src-address-list=allowed_to_router
add action=accept chain=input protocol=icmp
add action=accept chain=forward connection-state=established,related
add action=fasttrack-connection chain=forward comment=FastTrack \
    connection-state=established,related
add action=drop chain=input in-interface=ether1
add action=drop chain=forward in-interface=ether1 out-interface=bridge1
add action=drop chain=input connection-state=invalid
add action=drop chain=forward connection-state=invalid
add action=drop chain=forward comment=\
    "Drop tries to reach not public addresses from LAN" dst-address-list=\
    not_in_internet in-interface=bridge1 log=yes log-prefix=!public_from_LAN \
    out-interface=!bridge1
add action=drop chain=forward comment=\
    "Drop incoming packets that are not NAT`ted" connection-nat-state=!dstnat \
    connection-state=new in-interface=ether1 log=yes log-prefix=!NAT
add action=jump chain=forward comment="jump to ICMP filters" jump-target=icmp \
    protocol=icmp
add action=drop chain=forward comment=\
    "Drop incoming from internet which is not public IP" in-interface=ether1 \
    log=yes log-prefix=!public src-address-list=not_in_internet
add action=drop chain=forward comment=\
    "Drop packets from LAN that do not have LAN IP" in-interface=bridge1 log=\
    yes log-prefix=LAN_!LAN src-address=!10.10.0.0/24
add action=accept chain=icmp comment="echo reply" icmp-options=0:0 protocol=\
    icmp
add action=accept chain=icmp comment="net unreachable" icmp-options=3:0 \
    protocol=icmp
add action=accept chain=icmp comment="host unreachable" icmp-options=3:1 \
    protocol=icmp
add action=accept chain=icmp comment=\
    "host unreachable fragmentation required" icmp-options=3:4 protocol=icmp
add action=accept chain=icmp comment="allow echo request" icmp-options=8:0 \
    protocol=icmp
add action=accept chain=icmp comment="allow time exceed" icmp-options=11:0 \
    protocol=icmp
add action=accept chain=icmp comment="allow parameter bad" icmp-options=12:0 \
    protocol=icmp
add action=drop chain=icmp comment="deny all other types"
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
/system clock
set time-zone-name=Europe/Prague
/system package update
set channel=long-term
