#!/bin/sh 

VERBOSE=""
HELP="no"

#-------------------------------------------------------
#  Part 1: Check for and handle command-line arguments
#-------------------------------------------------------
for ARGI; do
    UNDEFINED_ARG=$ARGI
    if [ "${ARGI}" = "--verbose" -o "${ARGI}" = "-v" ] ; then
	VERBOSE="-v"
	UNDEFINED_ARG=""
    fi
    if [ "${ARGI}" = "--help" -o "${ARGI}" = "-h" ] ; then
	HELP="yes"
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
    printf "%s [SWITCHES]                       \n" $0
    printf "Switches:                           \n" 
    printf "  --verbose                         \n" 
    printf "  --help, -h                        \n" 
    exit 0;
fi


#-------------------------------------------------------
#  Part 2: Do the cleaning!
#-------------------------------------------------------

if [ "${VERBOSE}" = "-v" ]; then
    printf "Memory before: "; du -h | tail -1
fi

rm -rf  $VERBOSE   betty_* targ_*
rm -f   $VERBOSE   *~
rm -f   $VERBOSE   *.moos++
rm -f   $VERBOSE   .LastOpenedMOOSLogDirectory

if [ "${VERBOSE}" = "-v" ]; then
    printf "Memory after: "; du -h | tail -1
fi

