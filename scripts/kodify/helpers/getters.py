import os
import json
import shlex
import subprocess

from helpers import logger


def get_all_files(working_dir, excluded_dirs):
    list_of_files = []
    for (root, dirs, files) in os.walk(working_dir, topdown=True):
        dirs[:] = list(filter(lambda x: x not in excluded_dirs, dirs))
        list_of_files += [os.path.join(root, file) for file in files]

    # Filter out all .DS_Store files
    list_of_files = list(filter(lambda x: '.DS_Store' not in x, list_of_files))
    return list_of_files


def get_all_dirs(working_dir, excluded_dirs):
    list_of_dirs = []
    for (root, dirs, files) in os.walk(working_dir, topdown=True):
        dirs[:] = list(filter(lambda x: x not in excluded_dirs, dirs))
        list_of_dirs += [os.path.join(root, d) for d in dirs]
    return list_of_dirs


def get_output_from_terminal_cmd(cmd):
    proc = subprocess.Popen(
        cmd, shell=True, stdout=subprocess.PIPE,
        universal_newlines=True)
    outputlines = list(filter(lambda x: len(x) > 0, (line.strip()
                                                     for line in proc.stdout)))
    return outputlines


def run_terminal_cmd(cmd):
    mkvmerge = subprocess.run(cmd, shell=True)
    if mkvmerge.returncode != 0:
        logger.print_err('Failed!')
        return
    else:
        return mkvmerge.stdout


def get_mkvmerge_info(filename):
    cmd = "ffprobe -v quiet -print_format json -show_streams"
    args = shlex.split(cmd)
    args.append(filename)
    output = subprocess.check_output(args).decode('utf-8')
    output = json.loads(output)

    return output


def get_mkvmerge_info_alt(filename):
    cmd = "mkvmerge -J"
    args = shlex.split(cmd)
    args.append(filename)
    output = subprocess.check_output(args).decode('utf-8')
    output = json.loads(output)

    return output


def ask_for_confirmation(question):
    answer = input(question + '? y or n? ')
    if answer == 'y':
        logger.print_ok('   -> renamed.')
        return True
    else:
        logger.print_err('   -> skipped!!')
        return False
