#!/usr/bin/env python


import os
import pty
import socket
import threading
import signal
import subprocess
import select
import sys
import fcntl
import termios
import struct


os.umask(0o077)


def printhelp():
    print("""[94m""")

    subprocess.Popen(
        [
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "Radial"), 
            "--help"
        ],
        stderr=sys.stderr
    )
    print("""[0m""")


def printversion():
    print("""[94m
    v.1.0.1
    [0m""")


def printtest():
    print("test...")


def argument():
    try:
        match sys.argv[1].casefold():
            case '--help':
                printhelp()
                quit(0)

            case '--version':
                printversion()
                quit(0)

            case 'end':
                clean()

    except IndexError:
        ...



sock = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}") + "/Radial.sock"

def setBounds(fd):
    
    try:
        size = os.get_terminal_size()
        bounds = struct.pack(
            'HHHH',
            size[1] or 24,  #   rows
            size[0] or 80,  #   columns
            0,
            0
        )
    
    finally:
        fcntl.ioctl(fd, termios.TIOCSWINSZ, bounds)


def interpret(connection):

    data = connection.recv(1024).decode()

    if not data:
        data = ':'

    if data == "Threads.end".casefold():
        clean()

    else:
        with connection:
            # print("[94m    ", data, "[0m")
            interface, execution = pty.openpty()
            setBounds(execution)

            proc = subprocess.Popen(
                data,
                shell=True,
                stdin=execution,
                stdout=execution,
                stderr=execution,
                text=True,
                bufsize=1,
                env=os.environ.copy()
            )

            try:
                while True:
                    if proc.poll() is not None:
                        break

                    if select.select([interface], [], [], 0)[0]:
                        result = os.read(interface, 1024)
                        if result:
                            try:
                                connection.sendall(result)

                            except BrokenPipeError:
                                break

                        else:
                            break
            
            except KeyboardInterrupt:
                pass

            finally:
                os.close(interface)
                os.close(execution)

        proc.wait()


def monolith():

    global server
    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)


    try:
        server.bind(sock)

    except OSError:
        try:
            socket.socket(socket.AF_UNIX).connect(sock)
            sys.exit(0)

        except ConnectionRefusedError:
            os.remove(sock)
            server.bind(sock)
    
    server.listen(200)


    try:
        while True:
            connection, _ = server.accept()
            threading.Thread(target=interpret, args=(connection,), daemon=True).start()

    except KeyboardInterrupt:
        ...

    server.close()


def clean():
    print("[94m    Closing all threads[0m")
    os.system("pkill -f Radial.py &>/dev/null")
    try:
        os.kill(os.getpid(), signal.SIGINT)
    except:
        ...
    if os.path.exists(sock):
        os.remove(sock)
    exit(0)


def main():
    argument()
    monolith()


if __name__ == '__main__':
    main()

