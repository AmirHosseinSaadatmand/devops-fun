#!/bin/bash

# list of parameters
#  PROJECT_NAME REG_URL

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            PROJECT_NAME)        PROJECT_NAME=${VALUE} ;;
            REG_URL)        REG_URL=${VALUE} ;;
            BUILD_TAG)        BUILD_TAG=${VALUE} ;;
            *)
    esac

done




echo "********************"
echo "** Tagging image ***"
echo "********************"
docker tag $PROJECT_NAME:$BUILD_TAG $REG_URL/$PROJECT_NAME:$BUILD_TAG

echo "********************"
echo "** Pushing image ***"
echo "********************"

echo "docker push $REG_URL/$PROJECT_NAME:$BUILD_TAG"
docker push $REG_URL/$PROJECT_NAME:$BUILD_TAG
docker rmi -f $REG_URL/$PROJECT_NAME:$BUILD_TAG