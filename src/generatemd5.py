#!/usr/bin/env python3

import argparse
import hashlib
import os
import re
import shutil
from glob import glob


def main():
    parser = argparse.ArgumentParser(
        description="my script that renames files to md5 hashes"
    )
    parser.add_argument("path", type=str)
    args = parser.parse_args()

    all_files = glob(f"{args.path}/**/*", recursive=True)
    md5hex = re.compile(r"[0-9a-f]{32}")
    not_hashed = [
        fn
        for fn in all_files
        if (len(md5hex.findall(fn)) == 0) and (os.path.isfile(fn))
    ]

    for fn in not_hashed:
        path, filename_ext = os.path.split(fn)
        only_filename, ext = os.path.splitext(filename_ext)
        
        md5_hash = hashlib.md5(only_filename.encode()).hexdigest()

        src = f"{path}/{only_filename}{ext}"
        dst = f"{path}/{md5_hash}{ext}"

        print("renaming this file:", src, "to", dst)
        shutil.move(src=src, dst=dst)


if __name__ == "__main__":
    main()