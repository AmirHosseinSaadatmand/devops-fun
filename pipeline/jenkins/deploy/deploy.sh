#!/bin/bash

# list of parameters
#  PROJECT_NAME REG_URL PRD_SSH_KEY TARGET_SERVER_ADDRESS TARGET_SERVER_USER PRODUCT_PORT_NUMBER  BUILD_TAG

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            PROJECT_NAME)        PROJECT_NAME=${VALUE} ;;
            REG_URL)        REG_URL=${VALUE} ;;
            PRD_SSH_KEY)        PRD_SSH_KEY=${VALUE} ;;
            PRODUCT_PORT_NUMBER)        PRODUCT_PORT_NUMBER=${VALUE} ;;
            TARGET_SERVER_ADDRESS)        TARGET_SERVER_ADDRESS=${VALUE} ;;
            TARGET_SERVER_USER)        TARGET_SERVER_USER=${VALUE} ;;
            BUILD_TAG)        BUILD_TAG=${VALUE} ;;
            
            *)
    esac
done


echo "********************"
echo "*** Deploy image ***"
echo "********************"

echo "Stop old container"
ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "(docker stop $PROJECT_NAME > /dev/null && echo Stopped container $PROJECT_NAME &&   docker rm $PROJECT_NAME ) 2>/dev/null || true"
echo "Remove old images"
ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "(docker rmi --force \$(docker images -q '$REG_URL/$PROJECT_NAME' | uniq) > /dev/null && echo removed old $PROJECT_NAME images ) 2>/dev/null || true"



# # debug
# ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "docker run  -p $PRODUCT_PORT_NUMBER:$PRODUCT_PORT_NUMBER  --name $PROJECT_NAME $REG_URL/$PROJECT_NAME:$BUILD_TAG"

# deploy
ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "mkdir -p /opt/products/idbp/$PROJECT_NAME && docker run  -d -p  $PRODUCT_PORT_NUMBER:$PRODUCT_PORT_NUMBER  -v /opt/products/idbp/$PROJECT_NAME:/$PROJECT_NAME-app/logs --name $PROJECT_NAME $REG_URL/$PROJECT_NAME:$BUILD_TAG"
echo "Remove old images"
# ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "docker rmi  $(docker images -a | grep $PROJECT_NAME   | awk 'NR>1 {print $3}')   && echo removed old images  $PROJECT_NAME"
ssh -i $PRD_SSH_KEY $TARGET_SERVER_USER@$TARGET_SERVER_ADDRESS "(docker rmi --force \$(docker images -q '$REG_URL/$PROJECT_NAME' | uniq) > /dev/null && echo removed old $PROJECT_NAME images ) 2>/dev/null || true"

