# Mikrotik Configuration
### Info
System Edition: **Windows 10 Pro** \
Version: **22H2OS** \
Bulid: **19045.2251**

Program: **Winbox** \
Download date: **10/23/2022**

#### Connecting and reseting configuration or setting factory default
First of all, we have to plugged our ethernet cabel from our pc to 2nd, 3rd or 4th port. Why not 1st? By default configuration the 1st port is not available for connecting to admin panel and configuring, by firewall. Then we will start our program ```Winbox```. By default we should see the router board available in the list of available devices. If you can't see the available Mikrotik device below, you can just connect to it by it's MAC address, which is at the back of device. For example:

The MAC is smth like that **XX : XX : XX : XX : XX: X1** - **XX : XX : XX : XX : XX : X5** \
The numbers at the end symbolize the number of port. I use the **XX : XX : XX : XX : XX : X2**

There is more complicated way to see our device listed. You can read about it at the end of this manual.

There are few ways how we can start our configuration:
1. ##### We've never used mikrotik device before.
  - The default user (with full permissions) login is ```admin``` and there is no password.
  - We should see the welcome message and simply click to ```Remove configuration```, because we will configure later everything we need ourselves, we don't need the default settings and configuration.
2. ##### Somebody used mikrotik router board and we know login and password of user with full permissions.
  - After login to router board in menu on the left side choose ```System - Reset configuration```, choose ```No Default Configuration``` and click ```Reset configuration```.
  - The Mikrotik will reset all settings and configuration to default. Then we continue as in number 1. .
3. ##### Somebody used mikrotik router board, but we don't know login and password of user with full permissions.
  - You will lose all the configuration and any other data on the router after you reset it, please proceed with caution.
  - Most MikroTik devices are fitted with a reset button. Look for the reset button labeled with “RES” on your MikroTik router.
  -
    1. Turn off the device power.
    2. Hold the reset button and do not release.
    3. Turn on the device power and wait until the USER LED labeled with ```ACT``` starts.
    4. Now release the button to clear configuration.
    5. Wait for a few minutes for the router to clear and restore the factory settings.
  - If you release the reset button after the LED stops flashing, you have to redo everything again.
  - The Mikrotik will reset all settings and configuration to default. Then we continue as in number 1. .

#### Quick set
Don't forget to connect your Mikrotik to local network (connect on side of cable to main router and other side to 1st port of your Mikrotik) or basicaly that *cable from the wall*.


Now we don't have the connection to the internet, so let's fix this. We can set our configuration really quickly if we want to start from simple base configuration.

- Click the ```Quick Set``` on left side menu.
- Select Router, cause we need a network device, which will be work in network layer and we will focus on protocol address, creating local network (LAN) and sending information in packets.
-  If we are connecting to our main router (where is hopefully yet configurated DHCP and IP address from rage of local network is assigned to interface/port you connected to) or (wall cable) provider is able to give your Mikrotik automatic IP address, then choose ```Address Acquisition``` as Automatic. If not ask your provider or main router administrator for static IP address (or PPPoE credentials).
- The MAC address is given by default and it is the MAC address of 1st port interface, where the internet flow will come and go away.
- As local network I am personaly assigning.
```
IP Address: 10.10.0.1
Netmask: 255.255.255.0(/24)
DHCP Server Range: 10.10.0.10-10.10.0.254
```
- Also choose ``` NAT ```, ```DHCP``` and ```Bridge All LAN Ports``` (so not only port that we are configuring through have the access to the internet, before newer firmware versions, it was made not by bridge, but by assigning master port to each port, which we are wanting to have internet access) options.
- Click Apply and wait a bit.

#### Creating new admin user
We don't want to have our default user with no password. So let's create new user and grand him full access.
- Go to ```System - Users```.
- Create new user with strong password and grand him full permissions (assign group ```full```).
- Remove default admin user.
- Reconnect to Mikrotik device by new user.

#### Checking
Now, we suppose to have basic configuration up. But let's check what we have configured, why and in my case I will make some changes.

1. ##### Check the internet connection.
  - Now we suppose to have internet connection on our PC, but there are few ways to check it, and if we don't have internet connection on our PC we will find the place, where it fails.
  - Go to ```IP - DHCP Client```, we should see something like ```ether1 (1st port)``` has the assinged automatic port by main router or your provider, or static port that u have been given by main router administrator or provider.
  Also you should see Status as ```bound```.
  - If you see smth like ```searching```, means that problem is in assigned ip address.
  - Also we will run the ping. Go to ```Tools - Ping```. In my case I am pinging the website *nix.cz*.
  - And also we will run the ping for exmpl. to google dns ```8.8.8.8``` on our PC by opening CMD and run ```ping 8.8.8.8 -t```. If we can't reach network, that means, that we have bad configuration on our PC, for example in our ethernet card we have selected following IP address, not automatic. Go to ```Control Panel\Network and Internet\Network and Sharing Center```, choose on left menu *Change Adapter Settings*, right click on Ethernet card, Properties, double left click Internet Protocol Version 4.

2. ##### Bridge.
  - Go to ```Bridge```.
  - Check that there is a bridge, in my case ```bridge1```.
  - Why?
  - And in ```Port``` section we have all interfaces but 1st one. In my situation I disabled the 4th and 5th one, couse I won't need them.

3. ##### Interfaces.
  - Go to ```Interfaces```.
  - We should see our bridge here and all, in my case 5, ports.
  - In my case I disabled the 4th and 5th one, couse I won't need them.

4. ##### DHCP Server.
  - Go to ```IP - DHCP Server```. We should see that we have configured dhcp server ```dhcp1``` in my case, the interface is bridge1 (bridge will assign to each port in it the IP address from the given IP address pool).
  - In network tab we can view our local network (with IP's pool) that we have created in quick set.

5. ##### Routes.
  - Go to ```IP - Routes```. In my case I can see three routes:
  1. default route - with dst-address 0.0.0.0/0 applies to every destination address, in my case the gateway is the automatic given IP (IP of main router) through ether1 (1st port on my device). Such route is called the default route. If routing table contains an active default route, then routing table lookup in this table will never fail.
  2. Then route with dst-address of my local network IP pool (10.10.0.0/24) through bridge1.
  3. And last route with, in my case, dst-address of main router local IP pool (192.168.0.0/24) through ether1 (1st port on my device).

6. ##### NAT.
  - Go to ```IP - Firewall``` firstly to tab ```NAT```.
  - And this is where are hosts allowed on local area networks to use one set of IP addresses for internal communications and another set of IP addresses for external communications, basicaly when we did not set the Network Address Translation, our port won't receive the internet traffic (but our router will still be able to reach the internet network).
  - In my case I have the ```srcnat``` chain with ```WAN``` as OUTPUT Interface, which means that NAT router replaces the private source address of an IP packet with a new public IP address as it travels through the router. A reverse operation is applied to the reply packets traveling in the other direction. We don't need ```dstnat```, couse it's mainly used to make hosts on a private network to be accessible from the Internet.
  - As asction I choose the ```masquerade```. This allows us to translate multiple IP addresses to another single IP address. We can use masquerade NAT to hide one or more IP addresses on your internal network behind an IP address that we want to make public. This public address is the address to which the private addresses are translated and has to be a defined interface on our system.

7. ##### Firewall.
Most of configurations I took from: https://help.mikrotik.com/docs/display/ROS/Building+Your+First+Firewall#BuildingYourFirstFirewall-Ipv4firewall
  - If some connections of input trafic is already established from our router or is somehow related to it, we accept.
  - If some connections from outside to our local network is already established from our local network or is somehow related to it, we accept.
  - We configure all input trafic from provider (from main router firstly in my case). All that we don't allow, we drop.
  - We configure all input trafic from outside to our local network (from main router or/and provider). All that we don't allow, we drop.
  - Drop invalid or unknown connections to our device.
  - Drop invalid or unknown connection to out local network.

#### Backup/Restore + Export config.
- Backup.
  - Go to ```Files``` and click Backup. Then type name and password and click Backup.
  - Right click to file and download it to your PC.
- Restore.
  - Go to ```Files``` and click Upload.
  - Upload the backup file, then click Restore and choose your backup file from files, insert password and click Restore.
- Export config.
  - Go to ```New Terminal``` and insert this command ```export file=myconfig.cfg```.
  - Download .rsc file from Mikrotik files.
  - To restore config, do the same steps as with backup.
