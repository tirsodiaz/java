#!/bin/sh
#===================================================================
#
# SUBJECT : Start, Stop the java ICC Importer Service
#
# HISTORY :
#
#   DATE       WHO COMMENT
# ---------    -----------------------------------
# 30-08-2024   STA  Creation ICC-47
#
#===================================================================

WLC_USER=websphere
USER=`whoami`
if [ "$USER" != "$WLC_USER" ]
then
   echo "You must be $WLC_USER !"
   exit 1
fi

export SCRIPT=`basename $0`
export APP_PATH=/opt/Bandol/importfile
export LOG_PATH=/var/log/appl/Batch/importfile
export SERVICE_NAME="ICC Importer"

STAMP=`date '+%Y_%m_%d'`

export FILE_LOG=$LOG_PATH/icc_transfer_importer_service$STAMP.log

#Load the default environment variables for the current environment
exportDefEnv(){
  . $APP_PATH/bin/env_exp.sh
}

#===================================================================
# init the environment
#===================================================================
if [ -f $APP_PATH/bin/env_exp.sh ]
then
	echo "CURRENT home path  $HOME "
    
    exportDefEnv
       
    writelog "Default login $USERDBO"
    writelog "Default pwd $PASSWDDBO"
else
    writelog "ERROR Unknown library env_exp.sh"
    exit 2
fi

# Update the specific log to this process
writelog "------------ $SCRIPT ------------"
writelog "=========================================================   "
currentDate=`date '+ %d/%m/%Y %H:%M:%S'`
writelog "Date Time : $currentDate "
writelog "${SERVICE_NAME} Service request                       "
writelog "parameters : $*"

exitmode=1
export portnumber="10120"
export dbglvl="INFO"
export logformat="SIMPLE"
export logfileconfig="100000000,100"

while [[ $# > 0 ]]
do
	arg=$1
	shift
	case $arg in
	start|stop|kill|status)
        export reqmode=$arg
        writelog "$SCRIPT [ service : $SERVICE_NAME ]  : $reqmode"
        ;;
	-port)
		export portnumber=$1
		shift
		;;
	-dbglvl)
		export dbglvl=$1
		shift
		;;
#	-logFile)
#		export FILE_LOG=$1
#		shift
#		;;
	-help|-h)
		usage
		exitmode=2
		writelog "exit mode : ${exitmode}"
		exit ${exitmode}
		;;
	*)	
		writelog "$SCRIPT [ service : ${SERVICE_NAME} ]  : ${arg} - ERROR - unexpected argument "
		usage
		exitmode=-1
		writelog "exit mode : ${exitmode}"
		exit ${exitmode}
		;;
	esac
done

#-----------------------------
# initiate the command to exec 
#-----------------------------
export PATH=/opt/Websphere9/Liberty/java/8.0/bin:$PATH
export CLASSPATH=$APP_PATH/app/IccTransferImporterService.jar
export JAVA_ARGS=" -d64 -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=20 -XX:ConcGCThreads=5 -XX:InitiatingHeapOccupancyPercent=70 "

#Unix command to launch the service
cmd_to_exec="java -cp $CLASSPATH $JAVA_ARGS -Dport=${portnumber} -DdbUrl=jdbc:sybase:Tds:${DBSERVER}/${DBNAME}?CHARSET=iso_1&amp;IGNORE_DONE_IN_PROC=true -Dusername=${USERDBO} -Dpassword=${PASSWDDBO} -DLOG_FOLDER_PATH=${LOG_PATH} -DJASPER_OUTPUT_FOLDER=${JASPER_OUTPUT_FOLDER} org.springframework.boot.loader.JarLauncher --logfile $FILE_LOG --loglvl ${dbglvl}"

#--------------------------------------
# Main program
#--------------------------------------
if [ "$reqmode" = "status" ] 
then
	helpServices
	exitmode=$?
elif [ "$reqmode" = "start" ] 
then
	startServices "$cmd_to_exec"
	exitmode=$?
elif [ "$reqmode" = "stop" ] 
then
	killServices "$cmd_to_exec"
	exitmode=$?
elif [ "$reqmode" = "kill" ] 
then
	killServices "$cmd_to_exec"
	exitmode=$?
elif [ "$reqmode" = "help" ] 
then
	helpServices
	exitmode=$?
else
		echo "ERROR IN SYNTAX :"
        usage
        $FILE_LOG
        exit 1	
	exitmode=$?
fi
writelog " ${SERVICE_NAME} service log is $FILE_LOG xxx" 

writelog " Program Exit status $exitmode"
writelog "========== END ==============="

exit $exitmode
