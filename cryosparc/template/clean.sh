#!/bin/bash

shutdown_master () 
{
        echo "  Shutting down Cryosparc Master. "
        cryosparcm stop
}

cleanup () 
{
        echo "  Job is ending, cleaning up. "

        shutdown_master

        echo "  Removing sock lock file. "

        rm /tmp/cryosparc*sock
        rm /tmp/mongodb*sock

}
export PATH=$PATH:/home/users/$USER/cryosparc/$MUID/cryosparc_master/bin
cleanup




