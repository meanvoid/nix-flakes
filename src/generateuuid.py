#!/usr/bin/env python

import re
import os
import shutil
import uuid
from glob import glob

uuid4hex = re.compile(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}")

PATH = "/Users/marie/Downloads/"

all_files = glob(f"{PATH}/**/*", recursive=True)
not_uuid = [fn for fn in all_files if (len(uuid4hex.findall(fn)) == 0) and (os.path.isfile(fn))]

for fn in not_uuid:
  path, filename_ext = os.path.split(fn)
  only_filename, ext = os.path.splitext(filename_ext)
  
  src = f"{path}/{only_filename}{ext}"
  cmd = uuid.uuid1()
  dst = f"{path}/{cmd}{ext}"
  
  print("renaming this file:", src, "to", dst)
  shutil.move(src=src, dst=dst)
