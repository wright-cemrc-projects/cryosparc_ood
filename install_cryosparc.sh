#!/bin/bash


export CSPARCSRC=/path/to/dir/with/cryosparc/source/tarballs/cryosparc/
export CCACHE=/scratch/cryosparc/${USER}
export CUDA=/software/cuda/11.6
export UEMAIL=$USER

if [ "$UEMAIL" == "" ]; then
	echo need email
	exit
fi

LICENSE_ID=$1

if [ "$LICENSE_ID" == "" ]; then
	echo need license
	exit
fi

IMUID=$(getent passwd $UID | awk -F: '{print $3}')
if [ $IMUID -gt 65535 ]; then 
	echo UID $IMUID too big
	MUID=$(echo "$IMUID % 65535" | bc)
	# add the mod to the above result so we don't have clashes
	MUID=$(expr $MUID + $(expr $IMUID / $MUID))
else
	MUID=$IMUID
fi
if [ $IMUID -lt 2000 ]; then
	MUID=$(expr $IMUID \* 2 \+ 60000)
fi
echo port is $MUID 
export CHOME=/home/${USER}/cryosparc/$MUID


mkdir -p ${CHOME}
cd ${CHOME}
echo please waiting extrating cryosparc...
tar xzf ${CSPARCSRC}/cryosparc_master.tar.gz
tar xzf ${CSPARCSRC}/cryosparc_worker.tar.gz

UEMAIL="${USER}@[university].edu"

cd cryosparc_master
./install.sh --standalone --license $LICENSE_ID --worker_path ${CHOME}/cryosparc_worker --ssdpath ${CCACHE} --initial_email "${UEMAIL}" --initial_password "${USER}123" --initial_username "${USER}" --initial_firstname "${USER}" --initial_lastname "${USER}" --port ${MUID}

export PATH=$PATH:${CHOME}/cryosparc_master/bin

cryosparcm stop

echo ./install.sh --standalone --license $LICENSE_ID --worker_path ${CHOME}/cryosparc_worker --cudapath /usr/local/cuda-10.0 --ssdpath /u1/cryo/${USER} --initial_email "${UEMAIL}" --initial_password "${USER}123" --initial_username "${USER}" --initial_firstname "${USER}" --initial_lastname "${USER}" --port ${MUID}
