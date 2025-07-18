#   launch.nim


import os
import osproc
import std/strutils
import times
import posix


#   Environment
var loc = getAppDir()
var time = now().utc.format("ddHHmmssfff'Z'MMMyy")
var log = loc & "/logs/" & time
var sec = log & ".input.log"
var nonce = execProcess("openssl rand -hex 16")
var tmp = "/dev/shm/.arachne/" & strip(nonce)


if not dirExists(parentDir(tmp)):
    discard posix.mkdir(parentDir(tmp).cstring, 0o700)
else:
    setFilePermissions(parentDir(tmp), {fpUserWrite, fpUserRead, fpUserExec})


#   Arguments
var silent = false
var verbose = false
var arg: string
var mpi: string


proc arguments() =

    var list: seq[string]
    if paramCount() > 0: 
        list = " " & commandLineParams()
    let trim = proc(i: string) =
        list.delete(list.find(i))


    for i in commandLineParams():
        case i

            of ["--silent", "--quiet"]:
                silent = true
                trim(i)


            of "--verbose":
                verbose = true
                # trim(i)


            of "--logless":
                sec = "/dev/null"

            
            of "-":
                echo "launch.nim: --stdin detected"
                writeFile(tmp, stdin.readAll())
                mpi = " --input:" & tmp & " "


            else:
                discard
    
    arg = list.join(" ")


proc launch() =

    # var snare = loc & "/.resources/snare write"


    var inv = "script -qec \'"
    var path =  "/services/"
    var cmd = "Arachne" & arg
    # var sec = log & ".input.log"


    var invocation =  inv & loc & path & cmd & mpi & "\' " & sec


    if verbose:     echo invocation
    if verbose:     echo "    [94mExecuting command: [95m" & invocation & "[0m"
    if verbose:     stdout.write("\e[94m    Executing...\e[0m")
    if silent:      discard execCmd(invocation)
    if not silent:  discard execCmd(invocation)
    if verbose:     stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


proc cleanup() =
    removeFile(tmp)







proc main() =

    arguments()
    launch()
    cleanup()

main()
