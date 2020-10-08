import os

from helpers import getters
from helpers import logger
from helpers import os_utils
from helpers import mkv_utils


working_dir = os.getcwd()
backup_dir = '/Users/longdo/Downloads/old_macbook/filme/#fertig/#backup/'
mkvmerge_dir = '/Users/longdo/Downloads/old_macbook/filme/#fertig/#mkvmerge/'
output_dir = '/Users/longdo/Downloads/old_macbook/filme/#fertig/#output/'
excluded_dirs = {'#backup', '#mkvmerge', '#output'}


# TODO add option for .rar
def unzip_archives():
    files = getters.get_all_files(working_dir, excluded_dirs)
    archives = list(filter(lambda x: x.endswith('.zip'), files))
    for archive in archives:
        archive = archive.replace(working_dir + '/', '')
        os_utils.unzip(working_dir, archive)


def cleanup():
    dirs = getters.get_all_dirs(working_dir, excluded_dirs)
    for dirname in dirs:
        dirname = dirname.replace(working_dir + '/', '')
        os_utils.remove_unneeded_files(dirname)
    os_utils.remove_empty_dirs(working_dir, excluded_dirs)


# TODO - idea: remember all cmds and ask for confirm at the end
def rename():
    rename_episodes()
    rename_movies()


def rename_episodes():
    files = getters.get_all_files(working_dir, excluded_dirs)
    for filename in files:
        filename = filename.replace(working_dir + '/', '')
        # Split dirname and filename in case episodes are in season folders
        dirname = ''
        if '/' in filename:
            dirname = filename.split('/')[0] + '/'
            filename = filename.split('/')[1]
        os_utils.rename_episode(dirname, filename, mkvmerge_dir)


def rename_movies():
    files = getters.get_all_files(working_dir, excluded_dirs)
    for filename in files:
        filename = filename.replace(working_dir + '/', '')
        os_utils.create_movie_folder(filename)
    dirs = getters.get_all_dirs(working_dir, excluded_dirs)
    for dirname in dirs:
        dirname = dirname.replace(working_dir + '/', '')
        os_utils.rename_dir(dirname, mkvmerge_dir)


def mkvmerge():
    files = getters.get_all_files(mkvmerge_dir, [])
    for filename in files:
        # filename = filename.replace(working_dir + '/', '')
        mkv_utils.multiplex_episode(filename, output_dir)


def switch_case(user_input):
    switcher = {
        '1': unzip_archives,
        '2': cleanup,
        '3': rename,
        '4': mkvmerge,
        'q': lambda: quit()
    }
    func = switcher.get(user_input, lambda: logger.print_err('Invalid input!'))
    return func()


def main():
    # Create backup, mkvmerge, output folder, if necessary
    for dirname in excluded_dirs:
        if not os.path.isdir(working_dir + '/' + dirname):
            os.mkdir(dirname)

    while True:
        logger.print_log('\n' + 'ᕙ(⇀‸↼‶)ᕗ awaiting input..')
        user_input = input(
            ' 1: Unzip archives\n'
            ' 2: Clean up files (except .mkv .srt)\n'
            ' 3: Renaming episodes/movies\n'
            ' 4: Mkvmerging (keep only eng tracks)\n'
            ' q: quit!\n-> ')

        switch_case(user_input)


if __name__ == '__main__':
    main()
