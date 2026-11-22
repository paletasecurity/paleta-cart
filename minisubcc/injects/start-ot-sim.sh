#!/bin/bash
# Runs at boot (phenix startup scripts in /etc/phenix/startup/): start OT-sim
# with this node's injected config.
nohup ot-sim-cpu-module /etc/ot-sim/config.xml > /var/log/ot-sim.log 2>&1 &
