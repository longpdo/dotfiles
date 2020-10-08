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

            audio_stream = []
            try:
                for stream in media_info['tracks']:
                    if stream['type'] == 'audio':
                        audio_stream.append(stream)
            except KeyError:
                continue

            print(file)

            if len(audio_stream) > 1:
                logger.print_ok('Run mkvmerge on: ' + file)

                tmp_file = file.replace('.mkv', '_FIXED.mkv')
                cmd = "mkvmerge -o '" + tmp_file + "' -a 'jpn' -s 'und,eng' --default-track 0 --default-track 1"
                cmd += " --no-chapters --no-attachments --no-global-tags '" + file + "'"
                getters.run_terminal_cmd(cmd)


if __name__ == '__main__':
    main()
