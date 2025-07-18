#!/usr/bin/env python3


import socket
import os
import sys
import codecs






def monolith():
    sock = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}") + "/Radial.sock"
    message = ' '.join(sys.argv[1:])


    global connection
    connection = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)


    try:
        connection.connect(sock)

    except FileNotFoundError:
        print("[31m    >><<[94m Server could not be found[0m")
        exit(1)

    except ConnectionRefusedError:
        print("[31m    >><<[94m Server refused connection[0m")
        exit(1)


    connection.sendall(message.encode('utf-8'))
    connection.shutdown(socket.SHUT_WR)


    while True:
        data = connection.recv(1024)
        cipher = codecs.getincrementaldecoder("utf-8")(errors='replace')

        try:
            if not data:
                break

            print(cipher.decode(data), end='')

        except KeyboardInterrupt:
            break

    else:
        connection.close()
        print(os.environ.copy())


def main():
    monolith()


    print("[0m", end="")


if __name__ == '__main__':
    main()
