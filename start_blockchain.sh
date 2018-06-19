#!/bin/bash

RMBNA=$(ls *.bna 2> /dev/null);
RMCARD=$(ls *.card 2> /dev/null);
FABRIC=$(docker ps -aq --filter "name=peer*");
IMAGE=$(docker images | grep "user-0.0.1" | cut -d' ' -f1);
CONTAINER=$(docker ps -aq --filter "name=user-0.0.1");
NETWOKCARD=$(composer card list | grep admin@user);

#if [ ! -z "$FABRIC" ]
#then
#    stopFabric.sh
#    teardownFabric.sh
#fi

#startFabric.sh
#createPeerAdminCard.sh

if [ ! -z $RMBNA ]
then
    rm *.bna
fi

if [ ! -z $RMCARD ]
then
    rm *.card
fi

if [ -z $IMAGE ]
then
    echo "Trash image. Removing..."
    docker rm -f $CONTAINER
    docker rmi $IMAGE
fi
	

composer archive create -t dir -n .

composer network install \
    --card PeerAdmin@hlfv1 \
    --archiveFile user@0.0.1.bna

composer network start \
    --networkName user \
    --networkVersion 0.0.1 \
    --networkAdmin admin \
    --networkAdminEnrollSecret adminpw \
    --card PeerAdmin@hlfv1 \
    --file networkadmin.card

composer card import --file networkadmin.card

composer network ping --card admin@user
