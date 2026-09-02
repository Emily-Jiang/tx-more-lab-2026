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

# Start Deployment Manager 
echo "** Starting Deployment Manager..." >> "${LOG_FILE}"
$WAS_HOME/profiles/Dmgr01/bin/startManager.sh  >> "${LOG_FILE}"

# Check Deployment Manager Status
echo "Checking Deployment Manager Status..." >> "${LOG_FILE}"
$WAS_HOME/profiles/Dmgr01/bin/serverStatus.sh -all >> "${LOG_FILE}"

# Start Node Agent
echo "** Starting Node Agent ..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/startNode.sh >> "${LOG_FILE}"

# Start Server
echo "** Starting Server server1 ..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/startServer.sh server1 >> "${LOG_FILE}"

echo "Checking Status ..." >> "${LOG_FILE}"
$WAS_HOME/profiles/AppSrv01/bin/serverStatus.sh -all >> "${LOG_FILE}"
echo "All servers have been started!"
exit 0
