#!/usr/bin/env python

import re
import os
import shutil
import uuid
import argparse
from glob import glob

def main ():
  parser = argparse.ArgumentParser(description="my script that renames files to uuids")
  parser.add_argument('path', type=str)
  args = parser.parse_args()
  
  uuid4hex = re.compile(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}")
  all_files = glob(f"{args.path}/**/*", recursive=True)
  not_uuid = [fn for fn in all_files if (len(uuid4hex.findall(fn)) == 0) and (os.path.isfile(fn))]
  
  for fn in not_uuid:
    path, filename_ext = os.path.split(fn)
    only_filename, ext = os.path.splitext(filename_ext)
    
    src = f"{path}/{only_filename}{ext}"
    cmd = uuid.uuid1()
    dst = f"{path}/{cmd}{ext}"
    
    print("renaming this file:", src, "to", dst)
    shutil.move(src=src, dst=dst)

if __name__ == '__main__':
    main()