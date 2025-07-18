#!/usr/bin/env python

import os






nonce=(os.urandom(32).hex())
os.system("notify-send " + "\"Random string for this thread: " + nonce + "\"")
