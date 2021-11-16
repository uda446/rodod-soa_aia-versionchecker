# Information
This script is used to find out version of following products:
- WebLogic
  - PSU-Patch
- SOA-Suite
  - Bundle-Patch
- AIA Version
- JDK Version

# Usage
./getSoaAiaVersion.sh

# Sample Output
````
$ ./getSoaAiaVersion.sh 
**************************************************************
INFO: Detected a WebLogic Installation.
**************************************************************
Oracle WebLogic Version:
------------------------
Product Version: 12.2.1.4.0
Product Patch Update: WLS PATCH SET UPDATE 12.2.1.4.210629

Oracle SOA Suite Version Information:
-------------------------------------
Product Version : 12.2.1.4.0
Product Patch Update: SOA Bundle Patch 12.2.1.4.210928

Oracle AIA Version Information:
-------------------------------
Product Version: 12.2.1

Runtime JDK Version:
--------------------
java version "1.8.0_301"
Java(TM) SE Runtime Environment (build 1.8.0_301-b25)
Java HotSpot(TM) 64-Bit Server VM (build 25.301-b25, mixed mode)
**************************************************************
````