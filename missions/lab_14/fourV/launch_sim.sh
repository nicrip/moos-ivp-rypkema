#!/bin/bash 

WARP=1
HELP="no"
JUST_BUILD="no"
SIMULATE="no"
SIMVPLUGFILE="plug_SIMvessel.moos"
REALVPLUGFILE="plug_REALvessel.moos"
BAD_ARGS=""
CRUISESPEED=1.75

#-------------------------------------------------------
#  Part 1: Check for and handle command-line arguments
#-------------------------------------------------------
let COUNT=0
for ARGI; do
    UNDEFINED_ARG=$ARGI
    if [ "${ARGI:0:6}" = "--warp" ] ; then
        WARP="${ARGI#--warp=*}"
        let "COUNT=$COUNT+1"
        UNDEFINED_ARG=""
    fi
    # Handle Warp shortcut                                                      
    if [ "${ARGI//[^0-9]/}" = "$ARGI" -a "$COUNT" = 0 ]; then
        WARP=$ARGI
        let "COUNT=$COUNT+1"
        UNDEFINED_ARG=""
    fi
    if [ "${ARGI}" = "--help" -o "${ARGI}" = "-h" ] ; then
	HELP="yes"
	UNDEFINED_ARG=""
    fi
    if [ "${ARGI}" = "--just_build" -o "${ARGI}" = "-j" ] ; then
	JUST_BUILD="yes"
	UNDEFINED_ARG=""
    fi
    if [ "${UNDEFINED_ARG}" != "" ] ; then
	BAD_ARGS=$UNDEFINED_ARG
    fi
done

if [ "${BAD_ARGS}" != "" ] ; then
    printf "Bad Argument: %s \n" $BAD_ARGS
    exit 0
fi

if [ "${HELP}" = "yes" ]; then
    printf "%s [SWITCHES]            \n" $0
    printf "Switches:                \n"
    printf "  --just_build, -j       \n" 
    printf "  --help, -h             \n" 
    exit 0;
fi

#-------------------------------------------------------
#  Part 2: Create the .moos and .bhv files. 
#-------------------------------------------------------

VNAME1="archie"  # The archie vehicle Community
VPORT1="9100"
LPORT1="9101"
START_POS1="0,-20"      
LOITER_PT1="x=-10,y=-60"
RETURN_PT1="-10,-60"

VNAME2="betty"  # The betty vehicle Community
VPORT2="9200"
LPORT2="9201"
START_POS2="50,0"       
LOITER_PT2="x=50,y=-40"
RETURN_PT2="50,-40"

VNAME3="charlie"  # The charlie vehicle Community
VPORT3="9300"
LPORT3="9301"
START_POS3="0,-50"      
LOITER_PT3="x=-10,y=-90"
RETURN_PT3="-10,-90"

VNAME4="davis"  # The davis vehicle Community
VPORT4="9400"
LPORT4="9401"
START_POS4="50,-30"       
LOITER_PT4="x=50,y=-70"
RETURN_PT4="50,-70"

SNAME="shoreside"  # Shoreside Community
SPORT="9000"
SLPORT="9001"


# Prepare Archie files
nsplug meta_vehicle_sim.moos targ_archie.moos -f        \
    VNAME=$VNAME1 VPORT=$VPORT1 LPORT=$LPORT1           \
    START_POS=$START_POS1 WARP=$WARP                    \                 

nsplug meta_vehicle.bhv targ_archie.bhv -f              \
    VNAME=$VNAME1                                       \
    CRUISESPEED=$CRUISESPEED                            \
    LOITER_PT=$LOITER_PT1                               \
    RETURN_PT=$RETURN_PT1

# Prepare Betty files
nsplug meta_vehicle_sim.moos targ_betty.moos -f         \
    VNAME=$VNAME2 VPORT=$VPORT2 LPORT=$LPORT2           \
    START_POS=$START_POS2  WARP=$WARP                   \

nsplug meta_vehicle.bhv targ_betty.bhv -f               \
    VNAME=$VNAME2                                       \
    CRUISESPEED=$CRUISESPEED                            \
    LOITER_PT=$LOITER_PT2                               \
    RETURN_PT=$RETURN_PT2

# Prepare Charlie files
nsplug meta_vehicle_sim.moos targ_charlie.moos -f       \
    VNAME=$VNAME3 VPORT=$VPORT3 LPORT=$LPORT3           \
    START_POS=$START_POS3 WARP=$WARP                    \                 

nsplug meta_vehicle.bhv targ_charlie.bhv -f             \
    VNAME=$VNAME3                                       \
    CRUISESPEED=$CRUISESPEED                            \
    LOITER_PT=$LOITER_PT3                               \
    RETURN_PT=$RETURN_PT3

# Prepare Betty files
nsplug meta_vehicle_sim.moos targ_davis.moos -f         \
    VNAME=$VNAME4 VPORT=$VPORT4 LPORT=$LPORT4           \
    START_POS=$START_POS4  WARP=$WARP                   \

nsplug meta_vehicle.bhv targ_davis.bhv -f               \
    VNAME=$VNAME4                                       \
    CRUISESPEED=$CRUISESPEED                            \
    LOITER_PT=$LOITER_PT4                               \
    RETURN_PT=$RETURN_PT4

# Prepare Shoreside files
nsplug meta_shoreside.moos targ_shoreside.moos -f       \
    SLPORT=$SLPORT                                      \
    SPORT=$SPORT                                        \
    SNAME=$SNAME                                        \
    WARP=$WARP                                          \
    LOITER_PT1=$LOITER_PT1                              \
    LOITER_PT2=$LOITER_PT2                              \
    LOITER_PT3=$LOITER_PT3                              \
    LOITER_PT4=$LOITER_PT4

if [ ${JUST_BUILD} = "yes" ] ; then
    exit 0
fi

#-------------------------------------------------------
#  Part 3: Launch the processes
#-------------------------------------------------------

# Launch Archie
printf "Launching Archie MOOS Community \n"
pAntler targ_archie.moos >& /dev/null &
sleep 0.1

# Launch Betty
printf "Launching Betty MOOS Community \n"
pAntler targ_betty.moos >& /dev/null &
sleep 0.1

# Launch Charlie
printf "Launching Charlie MOOS Community \n"
pAntler targ_charlie.moos >& /dev/null &
sleep 0.1

# Launch Davis
printf "Launching Davis MOOS Community \n"
pAntler targ_davis.moos >& /dev/null &
sleep 0.1

# Launch shorestation 
printf "Launching $SNAME MOOS Community \n"
pAntler targ_shoreside.moos >& /dev/null &

#-------------------------------------------------------
#  Part 4: Exiting and/or killing the simulation
#-------------------------------------------------------

ANSWER="0"
while [ "${ANSWER}" != "1" -a "${ANSWER}" != "2" ]; do
    printf "Now what? (1) Exit script (2) Exit and Kill Simulation \n"
    printf "> "
    read ANSWER
done

# %1, %2, %3 matches the PID of the first three jobs in the active
# jobs list, namely the three pAntler jobs launched in Part 3.
if [ "${ANSWER}" = "2" ]; then
    printf "Killing all processes ... \n "
    kill %1 %2 %3
    printf "Done killing processes.   \n "
fi
