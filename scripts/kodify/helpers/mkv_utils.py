import shutil
import re

from helpers import getters
from helpers import logger
from helpers import regex_utils


# Remove everything except eng and ger streams
def multiplex_episode(filename, destination_path):
    media_info = getters.get_mkvmerge_info(filename)
    logger.print_log('Multiplexing: ' + filename)

    if len(media_info['streams']) <= 2:
        logger.print_exit('No subtitle found.')
        return

    if len(media_info['streams']) <= 3:
        # TODO make this better only one get method needed?
        media_info = getters.get_mkvmerge_info_alt(filename)

        audio_stream, subtitle_stream = [], []
        for stream in media_info['tracks']:
            if stream['type'] == 'audio':
                audio_stream.append(stream)
            if stream['type'] == 'subtitles':
                subtitle_stream.append(stream)

        audio, subtitle = '', ''

        if len(audio_stream) == 1:
            # if audio tag is und --> set to eng
            if audio_stream[0]['properties']['language'] == 'und':
                audio += ' --edit track:a1 --set language=eng'
            audio += ' --edit track:a1 --set flag-default=1'

        if len(subtitle_stream) == 1:
            # if audio tag is und --> set to eng
            if subtitle_stream[0]['properties']['language'] == 'und':
                subtitle += ' --edit track:s1 --set language=eng'
            subtitle += ' --edit track:s1 --set flag-default=1'

        if audio and subtitle is not '':
            logger.print_ok('Run mkvpropedit on: ' + filename)
            cmd = "mkvpropedit " + audio + subtitle + " '" + filename + "'"
            getters.run_terminal_cmd(cmd)

            if not regex_utils.is_tv_episode(filename):
                filename = regex_utils.get_name_until_year(filename)

            shutil.move(filename, filename.replace('#mkvmerge', '#output'))
    else:
        print('Run mkvmerge on: ' + filename)

        tmp_file = filename.replace('#mkvmerge', '#backup')
        # TODO instead of using 1 -> use index of first audio track
        cmd = "mkvmerge -o '" + tmp_file + "' -a 1 -s 'und,eng,ger' --default-track 0 --default-track 1"
        cmd += " --no-chapters --no-attachments --no-global-tags '" + filename + "'"
        getters.run_terminal_cmd(cmd)

        media_info_tmp = getters.get_mkvmerge_info(tmp_file)

        # TODO remove forced subtitle tracks - das muss ja schon vor mkvmerge passieren....
        # TODO set eng sub as default
        subtitle_stream_tmp = []
        for stream in media_info_tmp['streams']:
            if stream['codec_type'] == 'subtitle':
                subtitle_stream_tmp.append(stream)

        logger.print_ok('Run mkvpropedit on: ' + filename)
        cmd = "mkvpropedit --edit track:s1 --set flag-default=1 '" + tmp_file + "'"
        getters.run_terminal_cmd(cmd)

        # Remove everything after (YEAR) if the file is not a tv episode
        if not regex_utils.is_tv_episode(filename):
            filename = regex_utils.get_name_until_year(filename)
            tmp_file = regex_utils.get_name_until_year(tmp_file)

        # Move resulted tmp file to output
        shutil.move(tmp_file, filename.replace('#mkvmerge', '#output'))
        # Move original file to backup
        shutil.move(filename, filename.replace('#mkvmerge', '#backup'))


def append_media_info_tags(filename, media_info):
    result = regex_utils.get_episode_name(filename).strip().replace(' ', '.')
    tag_part = regex_utils.get_episode_tags(filename)

    result = _append_resolution_tag(result, media_info['streams'][0]['width'])

    if '10' in media_info['streams'][0]['profile']:
        result = result + '.10bit'

    if 'q22' in tag_part:
        result = result + '.Q22'
    # Append FSxx or Sxx if there are any
    m = re.findall(r'F?[S]\d{2}', tag_part)
    if m:
        for match in m:
            result = result + '.' + match

    result = _append_source_tag(result, tag_part)
    result = _append_audio_channel_tag(result, str(media_info['streams'][1]['channels']))
    result = _append_video_codec_tag(result, media_info['streams'][0]['codec_name'])
    result = _append_encoder_tag(result, tag_part)
    return result


def _append_resolution_tag(filename, resolution_info):
    if 1280 == resolution_info:
        filename += '.720p'
    if 1920 == resolution_info:
        filename += '.1080p'
    if 3840 == resolution_info:
        filename += '.2160p'
    return filename


def _append_source_tag(filename, tag_part):
    sources = ['BluRay', 'WEBRip', 'WEB-DL']
    for source in sources:
        if source in tag_part:
            filename = filename + '.' + source
    if 'BluRay' not in filename:
        if getters.ask_for_confirmation('No source found. Want to add BluRay as source?'):
            filename = filename + '.BluRay'
    return filename


# TODO problem if audio is not at index 1
def _append_audio_channel_tag(filename, channel_info):
    return filename + '.' + channel_info + 'CH'


def _append_video_codec_tag(filename, codec_info):
    if 'hevc' in codec_info:
        filename = filename + '.x265.HEVC'
    if 'h264' in codec_info:
        filename = filename + '.x264.AVC'
    return filename


def _append_encoder_tag(filename, tag_part):
    encoders = ['PSA', 'Joy', 'Tigole', 'Qman']
    for encoder in encoders:
        if encoder in tag_part:
            filename += '-' + encoder
    return filename
