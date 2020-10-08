import os

from helpers import getters


def main():
    path = os.getcwd()
    files = getters.get_all_files(path, [])
    for file in files:
        file = file.replace(path + '/', '')

        if file.endswith('.mkv'):
            info = getters.get_mkvmerge_info_alt(file)
            if len(info['tracks']) > 3:
                continue
            print(str(len(info['tracks'])) + ' -> ' + file)


if __name__ == '__main__':
    main()
