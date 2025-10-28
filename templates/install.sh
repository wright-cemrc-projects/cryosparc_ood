#!/bin/bash

# $1 is first argument, $2 second argument
USER="$1"
MUID="$2"

# Customize these to match your queues and installation directories:
SLURM_QUEUES=("a100" "a5000" "r5000")
export CHOME=/mnt/hpc_users/home/${USER}/cryosparc/${MUID}

echo "Setting up in ${CHOME}"

# Everything is relative to this script directory
cd "$(dirname ${BASH_SOURCE[0]})"

# Copy over the start-up splash pages
cp -r pages ${CHOME}/pages

# Copy over the queues, customize, and install
mkdir -p ${CHOME}/queues

for SQ in "${SLURM_QUEUES[@]}"; do
  cp -r queues/slurm_template ${CHOME}/queues/${SQ}
  sed -i "s|{{CHOME}}|${CHOME}|g" ${CHOME}/queues/${SQ}/cluster_info.json 
  sed -i "s|{{QUEUE}}|${SQ}|g" ${CHOME}/queues/${SQ}/cluster_info.json 
done

# Tell CryoSPARC about these configs; CryoSPARC must be running
for SQ in "${SLURM_QUEUES[@]}"; do
  cd ${CHOME}/queues/${SQ}
  cryosparcm cluster connect
done

# DONE!
echo "SLURM queue setup for CryoSPARC complete."
