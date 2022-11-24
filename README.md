# Mikrotik Configuration
### Info
System Edition: **Windows 10 Pro** \
Version: **22H2OS** \
Bulid: **19045.2251**

Program: **Winbox** \
Download date: **10/23/2022**

### VIDEO

[VIDEO](https://www.youtube.com/watch?v=vKZFn9Fng2Q)

[Connecting and reseting configuration or setting factory default](#connecting-and-reseting-configuration-or-setting-factory-default)
  1. [We've never used mikrotik device before](#weve-never-used-mikrotik-device-before)
  2. [Somebody used mikrotik router board and we know login and password of user with full permissions](#somebody-used-mikrotik-router-board-and-we-know-login-and-password-of-user-with-full-permissions)
  3. [Somebody used mikrotik router board, but we don't know login and password of user with full permissions](#somebody-used-mikrotik-router-board-but-we-dont-know-login-and-password-of-user-with-full-permissions)

[Quick set](#quick-set)
[Creating new admin user](#creating-new-admin-user)
[Checking](#checking)
  1. [Check the internet connection](#check-the-internet-connection)
  2. [Bridge](#bridge)
  3. [Interfaces](#interfaces)
  4. [DHCP Server](#dhcp-server)
  5. [Routes](#routes)
  6. [NAT](#nat)
  7. [Firewall](#firewall)

[Backup/Restore + Export config](#backuprestore--export-config)

#### Connecting and reseting configuration or setting factory default
First of all, we have to plugged our ethernet cabel from our pc to 2nd, 3rd or 4th port. Why not 1st? By default configuration the 1st port is not available for connecting to admin panel and configuring, by firewall. Then we will start our program ```Winbox```. By default we should see the router board available in the list of available devices. If you can't see the available Mikrotik device below, you can just connect to it by it's MAC address, which is at the back of device. For example:

The MAC is smth like that **XX : XX : XX : XX : XX: X1** - **XX : XX : XX : XX : XX : X5** \
The numbers at the end symbolize the number of port. I use the **XX : XX : XX : XX : XX : X2**

There is more complicated way to see our device listed. You can read about it at the end of this manual.

There are few ways how we can start our configuration:
1. ##### We've never used mikrotik device before.
  - The default user (with full permissions) login is ```admin``` and there is no password.
  ![Capture1](https://user-images.githubusercontent.com/118899872/203673227-5c0391b5-6e98-4f68-bd1c-2028bf30a378.PNG)

  - We should see the welcome message and simply click to ```Remove configuration```, because we will configure later everything we need ourselves, we don't need the default settings and configuration.
  ![Capture8](https://user-images.githubusercontent.com/118899872/203673255-1e714675-8f06-4ba8-b093-2b972c06a61f.PNG)

2. ##### Somebody used mikrotik router board and we know login and password of user with full permissions.
  - After login to router board in menu on the left side choose ```System - Reset configuration```, choose ```No Default Configuration``` and click ```Reset configuration```.
  ![Menu System](https://user-images.githubusercontent.com/118899872/203673623-0ca8960b-2879-49a7-8901-dd219480bd7a.PNG)
  ![Reset Configuration](https://user-images.githubusercontent.com/118899872/203673638-79223922-18a8-46f4-80aa-b62789ab562e.PNG)

  - The Mikrotik will reset all settings and configuration to default. Then we continue as in number 1. .
3. ##### Somebody used mikrotik router board, but we don't know login and password of user with full permissions.
  - You will lose all the configuration and any other data on the router after you reset it, please proceed with caution.
  - Most MikroTik devices are fitted with a reset button. Look for the reset button labeled with “RES” on your MikroTik router.
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
![Menu Quick Set](https://user-images.githubusercontent.com/118899872/203673699-b095d3ef-8c2e-46a8-9e68-44ef81956771.PNG)

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
![Quick Set](https://user-images.githubusercontent.com/118899872/203673732-aea60517-8bb2-4993-a589-784a6015e44d.PNG)

- Click Apply and wait a bit.

#### Creating new admin user
We don't want to have our default user with no password. So let's create new user and grand him full access.
- Go to ```System - Users```.
![Menu System](https://user-images.githubusercontent.com/118899872/203673756-94e4d10d-5a7c-462a-89dd-8e19485dbcdd.PNG)

- Create new user with strong password and grand him full permissions (assign group ```full```).
- Remove default admin user.
![New User](https://user-images.githubusercontent.com/118899872/203673859-1e763c6c-acc1-415e-883c-1e731c141167.PNG)

- Reconnect to Mikrotik device by new user.

#### Checking
Now, we suppose to have basic configuration up. But let's check what we have configured, why and in my case I will make some changes.

1. ##### Check the internet connection.
  - Now we suppose to have internet connection on our PC, but there are few ways to check it, and if we don't have internet connection on our PC we will find the place, where it fails.
  - Go to ```IP - DHCP Client```, we should see something like ```ether1 (1st port)``` has the assinged automatic port by main router or your provider, or static port that u have been given by main router administrator or provider.
  ![Menu IP](https://user-images.githubusercontent.com/118899872/203673904-3ee4591d-bcbc-4bf5-9bab-f453788c972e.PNG)

  Also you should see Status as ```bound```.
  - If you see smth like ```searching```, means that problem is in assigned ip address.
  ![DHCP Client](https://user-images.githubusercontent.com/118899872/203673933-977267ab-b363-42df-933a-18aee25da760.PNG)

  - Also we will run the ping. Go to ```Tools - Ping```. In my case I am pinging the website *nix.cz*.
  ![Menu Tools](https://user-images.githubusercontent.com/118899872/203673955-d8879f11-ef4c-4c68-98f6-0dd2be7db23d.PNG)
  ![Ping](https://user-images.githubusercontent.com/118899872/203673964-c9550b21-badd-4760-aea1-41b0ad919853.PNG)
  - And also we will run the ping for exmpl. to google dns ```8.8.8.8``` on our PC by opening CMD and run ```ping 8.8.8.8 -t```. If we can't reach network, that means, that we have bad configuration on our PC, for example in our ethernet card we have selected following IP address, not automatic. Go to ```Control Panel\Network and Internet\Network and Sharing Center```, choose on left menu *Change Adapter Settings*, right click on Ethernet card, Properties, double left click Internet Protocol Version 4.

2. ##### Bridge.
  - Go to ```Bridge```.
  ![Menu Bridge](https://user-images.githubusercontent.com/118899872/203673985-5c5ea6cf-1665-48f2-a8f3-15f268966808.PNG)
  - Check that there is a bridge, in my case ```bridge1```.
  ![Bridge Bridge](https://user-images.githubusercontent.com/118899872/203674207-65954553-179c-41ac-b3a1-9df42fbe41cf.PNG)

  - Why? It is a function that accommodates multiple interfaces in one virtual interface. (And then the bridge1 DHCP server automaticaly assignes IP addresses from given pool.)
  - And in ```Port``` section we have all interfaces but 1st one. In my situation I disabled the 4th and 5th one, couse I won't need them.
  ![Bridge Ports](https://user-images.githubusercontent.com/118899872/203674215-553a0114-d24b-40d3-b9da-7c8dd3d46422.PNG)


3. ##### Interfaces.
  - Go to ```Interfaces```.
  ![Menu Interfaces](https://user-images.githubusercontent.com/118899872/203674238-51836576-12b7-4bbe-b5a1-11f8e2a727cc.PNG)

  - We should see our bridge here and all, in my case 5, ports.
  - In my case I disabled the 4th and 5th one, couse I won't need them.
  ![Interface List](https://user-images.githubusercontent.com/118899872/203674246-f165f695-d6f9-4b41-9d41-b24a84ddc9e4.PNG)


4. ##### DHCP Server.
  - Go to ```IP - DHCP Server```. We should see that we have configured dhcp server ```dhcp1``` in my case, the interface is bridge1 (bridge will assign to each port in it the IP address from the given IP address pool).
  ![Menu IP](https://user-images.githubusercontent.com/118899872/203674283-0179a795-7eef-436d-a642-075a0a8efa42.PNG)
  ![DHCP Server](https://user-images.githubusercontent.com/118899872/203674330-7c809e0a-f434-4a4f-a8bf-597d6a22cc41.PNG)
  ![DHCP Server Cfg](https://user-images.githubusercontent.com/118899872/203674348-df911d6c-5802-4324-9633-d02e0665df34.PNG)

  - In network tab we can view our local network (with IP's pool) that we have created in quick set.
  ![DHCP Server Networks](https://user-images.githubusercontent.com/118899872/203674359-0af074a8-6721-4f79-9b34-87cc415b4813.PNG)


5. ##### Routes.
  - Go to ```IP - Routes```. In my case I can see three routes:
  ![Menu IP](https://user-images.githubusercontent.com/118899872/203674388-3336fa22-43e8-443f-b31c-8f02bfc9fb0e.PNG)

    - default route - with dst-address 0.0.0.0/0 applies to every destination address, in my case the gateway is the automatic given IP (IP of main router) through ether1 (1st port on my device). Such route is called the default route. If routing table contains an active default route, then routing table lookup in this table will never fail.
    - Then route with dst-address of my local network IP pool (10.10.0.0/24) through bridge1.
    - And last route with, in my case, dst-address of main router local IP pool (192.168.0.0/24) through ether1 (1st port on my device).
    ![Route List](https://user-images.githubusercontent.com/118899872/203674403-ebb20528-2dac-4572-bfd1-1d8f134dfd71.PNG)



6. ##### NAT.
  - Go to ```IP - Firewall``` firstly to tab ```NAT```.
  ![Menu IP](https://user-images.githubusercontent.com/118899872/203674427-54ae06de-9beb-4aa4-8dd5-b05417730e49.PNG)
  ![Firewall NAT](https://user-images.githubusercontent.com/118899872/203674440-4ec1c75c-eb0d-4f22-b5a7-79ea26b513fa.PNG)

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
  ![image](https://user-images.githubusercontent.com/118899872/203674526-f24a7edf-38f7-4318-b523-944e4d30ff60.png)
BECAREFUL! The rules in firewall are going one after each other. If the trafic is blocked somehow, it won't go futher. Basicaly we put ACCEPT rules before DROP rules (it's more complicated in some cases). 

#### Backup/Restore + Export config.
- Backup.
  - Go to ```Files``` and click Backup. Then type name and password and click Backup.  
  - Right click to file and download it to your PC.
- Restore.
  - Go to ```Files``` and click Upload.
  - Upload the backup file, then click Restore and choose your backup file from files, insert password and click Restore.

  ![Menu Files](https://user-images.githubusercontent.com/118899872/203674761-33eb199b-61a7-4e6e-88f0-7cebdc9f3607.PNG)
  ![File List](https://user-images.githubusercontent.com/118899872/203674906-f3f2c946-7f27-4bbe-961c-6dc4dcec0a36.PNG)


- Export config.
  - Go to ```New Terminal``` and insert this command ```export file=myconfig.cfg```.
  - Download .rsc file from Mikrotik files.
  - To restore config, do the same steps as with backup.
