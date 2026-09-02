#!/bin/bash
# Configuration
readonly SCRIPT_NAME=$(basename "$0")

readonly USER_HOME="/home/itzuser"
readonly USER_TEMP_DIR="$USER_HOME/temp"
readonly USER_USR_DIR="$USER_HOME/usr"
readonly USER_VAR_DIR="$USER_HOME/var"
readonly SOFTWARE_DIR="$USER_HOME/software"

readonly LOG_DIR="$USER_HOME/logs"
readonly LOG_FILE="${LOG_DIR}/WAS_setup.log"
readonly ERROR_LOG="${LOG_DIR}/WAS_setup_errors.log"
readonly ABOUT_FILE="$USER_HOME/about_the_environment.txt"
readonly REPO_DIR="/tmp/post_deploy_repo"
readonly REPO_SCRIPT_DIR="$REPO_DIR/scripts"

readonly WAS_HOME="$USER_USR_DIR/IBM/WebSphere/AppServer"

# Stop the WAS instances
echo "** Stopping Server server1 ..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/stopServer.sh server1 >> "${LOG_FILE}"

echo "** Stopping Node Agent ..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/stopNode.sh >> "${LOG_FILE}"

# Stop Deployment Manager 
echo "** Stopping Deployment Manager..." >> "${LOG_FILE}"
$WAS_HOME/profiles/Dmgr01/bin/stopManager.sh  >> "${LOG_FILE}"

echo "Checking WAS Status..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/serverStatus.sh -all >> "${LOG_FILE}"
$WAS_HOME/profiles/Dmgr01/bin/serverStatus.sh -all >> "${LOG_FILE}"

exit 0
