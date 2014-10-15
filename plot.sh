#!/bin/bash
rm plot.dat
touch plot.dat

stty -F /dev/ttyACM0 cs7 cstopb -ixon raw speed 9600

regex="0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+).+0x([[:xdigit:]]+)"

start_time=`echo $(date +%s%N) | cut -b1-13`
read_data() {
    while read dataline; do
        echo $dataline
        if [[ $dataline =~ $regex ]]; then
            x1=`echo "ibase=16; ${BASH_REMATCH[1]}" | bc`
            x2=`echo "ibase=16; ${BASH_REMATCH[2]}" | bc`
            x3=`echo "ibase=16; ${BASH_REMATCH[3]}" | bc`
            y1=`echo "ibase=16; ${BASH_REMATCH[4]}" | bc`
            y2=`echo "ibase=16; ${BASH_REMATCH[5]}" | bc`
            y3=`echo "ibase=16; ${BASH_REMATCH[6]}" | bc`
            cur_time=`echo $(date +%s%N) | cut -b1-13`
            t=$((cur_time-start_time))
            echo -e $t"\t"$x1"\t"$x2"\t"$x3"\t"$y1"\t"$y2"\t"$y3 >> plot.dat
        fi
    done < /dev/ttyACM0
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

read_data & disown
read_data_pid=$!
sleep 1
gnuplot liveplot.gnu & disown
plot_data_pid=$!

# trap keyboard interrupt (ctrl-c)
trap ctrl_c SIGINT

while true; do read x; done
