# launch.nim







import os
import osproc
# import streams
# import std/strutils


proc help() =
    echo """[094m
    Create a server which receives shell commands from /Spiral.py. The commands are
    processed as threads and executed in parallel, with the output streamed back to
    the calling terminal. Use Radial.py once to establish the network, and then use
    Spiral.py <command> to open threads from anywhere else
    
    These threads self terminate, after not receiving input for a few seconds. This
    timer is reset by progress meters since they update the most recent line in cli

    Using /Radial.py end or /Spiral.py threads.end terminates the server and closes
    all open threads. If opened with /Spiral.py &  as a background process, the end
    command will close every Radial.py process. Radial resists duplication so it is
    safe to repeatedly open it as background processes, before adding threads to it
    [0m"""

proc version() =
    echo """[094m
        v1.0.1
    [0m"""

# Default flags
var quietitude = false
var verbosity = false

proc arguments() =

    # if paramCount() == 0:
    #     help()
    #     quit(0)

    for arg in commandLineParams():

        case arg
            of "--help":
                help()
                quit(0)
            of "--version":
                version()
                quit(0)

            of "--quiet":
                quietitude = true

            of "--verbose":
                verbosity = true

            else:
                discard
arguments()






##############################################################################################################################


var server =  "/.source/Radial/Rad.py "
var client =  "/.source/Radial/Arc.py "
var arg = " "
for i in 1 .. paramCount():
    arg.add(paramStr(i) & " ")
var loc = getAppDir()






proc launch() =
    

    if verbosity:       stdout.write("\e[94m    Executing...\e[0m")
    flushFile(stdout)

    discard execCmd(loc & server & " &")
    os.sleep(100)
    discard execCmd(loc & client & arg)

    if verbosity:       stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


proc main() =

    launch()

main()