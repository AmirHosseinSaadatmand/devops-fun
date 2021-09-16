#!/bin/bash

# list of parameters
# PROJECT_NAME JENKINS_DIR  

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            JENKINS_DIR)        JENKINS_DIR=${VALUE} ;;
            *)
    esac

done



cd $JENKINS_DIR/$JOB_NAME && find . -type f -iname '*.sh' -exec chmod +x {} \;
cd $JENKINS_DIR/$JOB_NAME && find . -type f -iname '*.sh' -exec sed -i -e 's/\r$//' {} \;