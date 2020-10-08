import os

from helpers import getters
from helpers import logger


def main():
    path = os.getcwd()
    files = getters.get_all_files(path, [])
    for file in files:
        # file = file.replace(path + '/', '')

        if file.endswith('.mkv'):
            media_info = getters.get_mkvmerge_info_alt(file)

            subtitle_stream = []
            for stream in media_info['tracks']:
                if stream['type'] == 'subtitles':
                    subtitle_stream.append(stream)

            subtitle = ''

            if len(subtitle_stream) == 1:
                # if audio tag is und --> set to eng
                if subtitle_stream[0]['properties']['language'] == 'und':
                    subtitle += ' --edit track:s1 --set language=eng'
                subtitle += ' --edit track:s1 --set flag-default=1'

            if subtitle is not '':
                logger.print_ok('Run mkvpropedit on: ' + file)
                cmd = "mkvpropedit " + subtitle + " '" + file + "'"
                getters.run_terminal_cmd(cmd)


if __name__ == '__main__':
    main()
