#!/bin/sh

CUR_DIR=`dirname $0`
export ORACLE_HOME=/opt/aia/Middleware_WLS12C
export SOA_HOME="${ORACLE_HOME}/soa"

# Following is needed to set JAVA_HOME
# Get WL_HOME 
MW_HOME=${ORACLE_HOME}
COMMON_COMPONENTS_HOME="${ORACLE_HOME}/oracle_common"

asType="UNKNOWN"

if [ -f ${MW_HOME}/oracle_common/common/bin/setHomeDirs.sh ]; then
   asType="WebLogic"
fi

case "${asType}" in
  "WebLogic" )
    echo "**************************************************************"
    echo "INFO: Detected a WebLogic Installation."
    echo "**************************************************************"
    . "${MW_HOME}/oracle_common/common/bin/setHomeDirs.sh"

    # Get JAVA_HOME
    . "${MW_HOME}/oracle_common/common/bin/commEnv.sh"
    ;;

  * )
    echo "ERROR: Unknown App Server"
    exit 1
    ;;
esac

LIB=$SOA_HOME/soa/modules/oracle.soa.fabric_11.1.1/oracle-soa-client-api.jar

# Display soa-infra version
MANIFEST_MF="unzip -p ${LIB} META-INF/MANIFEST.MF"
prodver=`$MANIFEST_MF | grep "Implementation-Version"| cut -d':' -f2 | sed -e "s/-SNAPSHOT//g;" | sed 's/^[ ]//g;s/[ ]//g'`
prodlbl=`$MANIFEST_MF | grep "Ade-Label"| cut -d':' -f2`
jdkver=`$MANIFEST_MF | grep "Build-Jdk"| cut -d':' -f2 | sed 's/^[ ]//g;s/[ ]//g'`

LIB=$ORACLE_HOME/soa/modules/oracle.soa.bpel_11.1.1/orabpel.jar
resources_version="unzip -p ${LIB} com/collaxa/cube/resources_version.properties"
CVS_TAG=`$resources_version | grep "CVS_TAG" | cut -d'=' -f2 | sed -e "s/-SNAPSHOT//g;s/ 12.1.4-//g" | sed 's/^[ ]//g;s/[ ]//g'`
PRODVERSION=`echo $CVS_TAG | cut -d '_' -f4`

# Display AIA version
AIAVERSION=$(perl -ne 'print $1 if /distribution status.*version="(.+)"/' /opt/aia/config/applications/OracleAIA_12C/inventory/registry.xml)

case $AIAVERSION in
   "13.9.0.0.0")
      export AIAVERSION=12.2.0
      ;;
   "13.9.4.0.0")
      export AIAVERSION=12.2.1
      ;;
esac

PATCHLIST=$($ORACLE_HOME/OPatch/opatch lspatches | awk '-F;' '/WLS PATCH SET UPDATE|SOA Bundle Patch/ {printf "%s;",$2}')
PATCHLIST=${PATCHLIST%;}

cat <<EOF
Oracle WebLogic Version:
------------------------
Product Version: $(java -cp /opt/aia/Middleware_WLS12C/wlserver/server/lib/weblogic.jar weblogic.version | awk '/WebLogic Server/ {print $3}')
Product Patch Update: ${PATCHLIST##*;}

Oracle SOA Suite Version Information:
-------------------------------------
Product Version : 12.2.1.4.0
Product Patch Update: ${PATCHLIST%%;*}

Oracle AIA Version Information:
-------------------------------
Product Version: $AIAVERSION

Runtime JDK Version:
--------------------
EOF
${JAVA_HOME}/bin/java -version

echo "**************************************************************"