import os
import shutil
from send2trash import send2trash
from zipfile import ZipFile

from helpers import getters
from helpers import logger
from helpers import regex_utils
from helpers import mkv_utils


def unzip(working_dir, archive):
    try:
        logger.print_log('Unzipping ' + archive)
        with ZipFile(archive) as zip_file:
            zip_file.extractall(working_dir)
    except:
        logger.print_err('Error while unzipping!')
        raise
    else:
        logger.print_ok(' -> finished. Removing ' + archive)
        send2trash(archive)


# Remove unneeded stuff except main video and subtitle files
def remove_unneeded_files(dirname):
    logger.print_log('Checking for cleanup in folder: ' + dirname)
    files_to_delete = _get_filtered_file_list(dirname)

    for file in files_to_delete:
        logger.print_ok(' -> deleting ' + file)
        send2trash(dirname + '/' + file)

    if len(os.listdir(dirname)) < 2:
        return
    else:
        _remove_movie_featurettes(dirname)


def remove_empty_dirs(working_dir, excluded_dirs):
    logger.print_log('Checking for empty folders.. ')
    list_of_dirs = getters.get_all_dirs(working_dir, excluded_dirs)

    # reversed order: bottom up
    for d in list_of_dirs[::-1]:
        d = d.replace(working_dir + '/', '')
        if not os.listdir(d):
            logger.print_ok(' -> deleting empty directory: ' + d)
            send2trash(d)


# TODO Problem when Sleepy.Hollow.S03E15.Incommunicado.720P.WEB-DL.2CH.x265.HEVC-PSA.mkv --> 720P instead of 720p
# TODO Umlaute unbenennen e.g. ä zu ae
# Function to rename tv show episodes
def rename_episode(dirname, filename, destination_path):
    if not regex_utils.is_tv_episode(filename):
        logger.print_exit('Exit: ' + filename + ' is not a TV episode.')
        return

    filename = _rename_special_chars(dirname, filename)
    # Episode already named -> move file
    if regex_utils.is_tv_episode_already_named(filename):
        logger.print_exit(
            'Exit: TV episode already named - moving file: ' + filename)
        shutil.move(dirname + filename, destination_path + filename)
        return

    logger.print_log('TV episode: ' + filename)
    stream_info = getters.get_mkvmerge_info(filename)
    result = mkv_utils.append_media_info_tags(filename, stream_info)
    result = _append_mkv_extension(result)

    if getters.ask_for_confirmation('   -> ' + result):
        os.rename(dirname + filename, destination_path + result)


def create_movie_folder(filename):
    if regex_utils.is_tv_episode(filename):
        logger.print_exit('Exit: ' + filename + ' is not a movie.')
        return
    if '/' in filename:
        logger.print_exit('Exit: Folder already exists for: ' + filename)
        return

    logger.print_log('Creating folder for: ' + filename)
    result = regex_utils.get_movie_name_with_year_in_parenthesis(filename)
    result = regex_utils.remove_special_chars(result)
    os.mkdir(result)
    shutil.move(filename, result)
    logger.print_ok('   -> created: ' + result)


def rename_dir(dirname, destination_path):
    if 'season' in dirname.lower():
        logger.print_exit('Exit: ' + dirname + ' is not a movie folder.')
        return
    if regex_utils.is_movie_folder_already_named(dirname):
        logger.print_ok('Exit: Folder already named: ' + dirname)
        rename_movie(dirname, os.listdir(dirname)[0], destination_path)
        return

    logger.print_log('Directory: ' + dirname)
    dirname = _rename_special_chars('', dirname)
    dir_tmp = regex_utils.get_movie_name_with_year_in_parenthesis(dirname)

    if getters.ask_for_confirmation('   -> ' + dir_tmp):
        os.rename(dirname, dir_tmp)
        rename_movie(dir_tmp, os.listdir(dir_tmp)[0], destination_path)


def rename_movie(dirname, filename, destination_path):
    filename = _rename_special_chars(dirname + '/', filename)
    if regex_utils.is_movie_already_named(filename):
        logger.print_ok('Exit: Movie already named: ' + filename)
        shutil.move(dirname, destination_path)
        return

    logger.print_log('Movie: ' + filename)
    old_filename = filename
    stream_info = getters.get_mkvmerge_info(dirname + '/' + old_filename)
    filename = regex_utils.remove_special_chars(filename)
    result = mkv_utils.append_media_info_tags(filename, stream_info)
    result = _append_mkv_extension(result)

    if getters.ask_for_confirmation('   -> ' + result):
        os.rename(dirname + '/' + old_filename, dirname + '/' + result)
        shutil.move(dirname, destination_path)


def _remove_movie_featurettes(dirname):
    # Get every file from dir except the largest file
    cmd = "find '" + dirname + "' -type f -exec du -a {} +"
    pipes = "| sort -n | cut -f2- | sed '$d'"
    cmd_output = getters.get_output_from_terminal_cmd(cmd + pipes)
    cmd_output_filtered = regex_utils.remove_episodes_from_list(cmd_output)

    if cmd_output_filtered is []:
        return
    for file in cmd_output_filtered:
        logger.print_ok(' -> deleting ' + file.replace(dirname + '/', ''))
        send2trash(file)


def _get_filtered_file_list(dirname):
    return list(filter(lambda x: os.path.isfile(dirname + '/' + x)
                       and not x.endswith('.srt')
                       and not x.endswith('.mkv'), os.listdir(dirname)))


def _append_mkv_extension(filename):
    return filename + '.mkv'


# Remove special chars and rename file
def _rename_special_chars(dirname, filename):
    result = filename.replace(' ', '.').replace("'", '')
    result = result.replace('..', '.').replace(
        '_', '.').replace('.-.', '.').replace('&', 'and')
    os.rename(dirname + filename, dirname + result)
    return result
