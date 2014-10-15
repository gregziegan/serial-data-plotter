# Hardware Trojan Project

Greg Ziegan (grz5)
Matt Prosser (mep99)

## Setup

If you don't already have this classic dependency...
    
    sudo apt-get install gnuplot


## Execution

    sudo ./plot.sh <port_name>

ie
    sudo ./plot.sh /dev/ttyACM0

To exit, just control-c the window running the process (it may or may not take a couple control-c's).


## Notes

We included a python file to show proof that we spent a lot of time working on the graphing in another language.
Bash turned out to be easier and MUCH more lightweight.

This should work on any linux machine that supports > gnuplot v4.0.

P.S.
Don't try this on Windows. I hope it works magically but that won't happen.
