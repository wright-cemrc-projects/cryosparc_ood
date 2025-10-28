#!/bin/bash


export CSPARCSRC=/mnt/hpc_users/share/resources/cryosparc/
export CCACHE=/mnt/scratch/cryosparc-${USER}
export CUDA=/user/local/cuda
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

hash=$(echo -n "$USER" | cksum | awk '{print $1}')

#min=2000
#max=65535
min=40000
max=41000
range=$((max - min + 1))
MUID=$(( (hash % range) + min ))

echo "$username -> $MUID"
echo port is $MUID 

export CHOME=/mnt/hpc_users/home/${USER}/cryosparc/$MUID


mkdir -p ${CHOME}
cd ${CHOME}
echo please waiting extracting cryosparc...
tar xzf ${CSPARCSRC}/cryosparc_master.tar.gz
tar xzf ${CSPARCSRC}/cryosparc_worker.tar.gz

UEMAIL="${USER}"

cd cryosparc_master
./install.sh --standalone --license $LICENSE_ID --worker_path ${CHOME}/cryosparc_worker --ssdpath ${CCACHE} --initial_email "${UEMAIL}" --initial_password "${USER}123" --initial_username "${USER}" --initial_firstname "${USER}" --initial_lastname "${USER}" --port ${MUID}

export PATH=$PATH:${CHOME}/cryosparc_master/bin

# Setup queues and startup pages

./template/install.sh "${USER}" "${MUID}"

# Finish the installation

cryosparcm stop

echo ./install.sh --standalone --license $LICENSE_ID --worker_path ${CHOME}/cryosparc_worker --cudapath ${CUDA} --ssdpath ${CCACHE} --initial_email "${UEMAIL}" --initial_password "${USER}123" --initial_username "${USER}" --initial_firstname "${USER}" --initial_lastname "${USER}" --port ${MUID}
