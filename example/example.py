#!/usr/bin/env python


import subprocess
from pathlib import Path
import os
import subprocess






path = os.path.join(Path(__file__).parent.parent, "launch ")
args = "script.json"


subprocess.run(path + args, shell=True)
