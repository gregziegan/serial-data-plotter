#!/bin/bash

# Greg Ziegan (grz5)
# Matt Prosser (mep99)
# File to read and spawn plotting process from data transmitted over serial bus

rm plot.dat
touch plot.dat

if [[ $# -ne 1 ]]; then
    echo "Please provide port in the form: /dev/ttyACM*"
    exit 1
fi

port=$1
stty -F $port cs7 cstopb -ixon raw speed 9600

# the following regex will search for the first 6 hexadecimal values on a line and capture each
regex="0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+)"

start_time=`echo $(date +%s%N) | cut -b1-13`  # conversion from seconds from epoch > milliseconds
read_data() {
    while read dataline; do
        echo $dataline
        if [[ $dataline =~ $regex ]]; then
            x1=`echo "ibase=16; ${BASH_REMATCH[1]}" | bc`  # the following lines convert the string to its decimal value
            x2=`echo "ibase=16; ${BASH_REMATCH[2]}" | bc`
            x3=`echo "ibase=16; ${BASH_REMATCH[3]}" | bc`
            y1=`echo "ibase=16; ${BASH_REMATCH[4]}" | bc`
            y2=`echo "ibase=16; ${BASH_REMATCH[5]}" | bc`
            y3=`echo "ibase=16; ${BASH_REMATCH[6]}" | bc`
            cur_time=`echo $(date +%s%N) | cut -b1-13`
            t=$((cur_time-start_time))  # time axis range
            echo -e $t"\t"$x1"\t"$x2"\t"$x3"\t"$y1"\t"$y2"\t"$y3 >> plot.dat  # append to data file
        fi
    done < $port
}

ctrl_c() {
    echo -en "\nExiting cleanly!\n"
    cleanup
    exit
}

cleanup() {
    kill $read_data_pid
    kill $plot_data_pid
    return $?
}

read_data & disown  # starts the reading process in background
read_data_pid=$!    # keep track of pid to exit cleanly
sleep 1
gnuplot liveplot.gnu & disown  # same concept as above
plot_data_pid=$!

# trap keyboard interrupt (ctrl-c)
trap ctrl_c SIGINT

while true; do read x; done  # master loop, will exit all processes upon exit
