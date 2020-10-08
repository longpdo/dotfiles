import re

from helpers import logger


chars = '([a-zA-Z0-9.-]+)'
opt_chars = '(.[a-zA-Z0-9.-]+)?'
year = '.(\d{4})'
episode_number = '.S\d{2}E\d{2}'
resolution = '.(720p|1080p|2160p)'
bit_depth = '(.10bit)?'
quality = '(.Q\d{2})?(.FS\d{2})?(-S\d{2})?'
source = '.(BluRay|WEBRip|WEB-DL|HDTV|BrRip)'
audio_ch = '.(2CH|6CH|8CH)'
video_codec = '.(x265.AVC|x265.HEVC)'
encoder = '-(PSA|Joy|Tigole|Qman)'

special_chars = '[!|?|_|(|)|\[|\]|,|]'
season_episode_number = 'S\d{2}E\d{2}'


def get_movie_name_with_year_in_parenthesis(filename):
    name_part = re.search(r'.*(\d{4})(\))?(?!p)', filename).group()
    name_part_with_parenthesis = re.sub(
        r'(?<!\()\d{4}(?!\))', '(\g<0>)', name_part)
    return name_part_with_parenthesis


def get_name_until_year(filename):
    match = re.search('.*\(\d{4}\)', filename)
    if match:
        return match.group(0)


def get_episode_name(filename):
    # Remove everything after matching resolution, e.g. .720p.WEBRip.2CH.x265.HEVC-PSA.mkv
    name_part = re.sub(rf'{resolution}.+', '', filename)
    return name_part


def get_episode_tags(filename):
    tag_part = re.search(rf'{resolution}.+', filename)
    return tag_part.group(0)


def is_tv_episode(filename):
    is_episode = re.search(rf'{season_episode_number}.+.mkv', filename)
    return is_episode


# SeriesName.S00E00.Title.{resolution}.{bit_depth}.{source}.{audio_ch}.{video_codec}-{encoder}
def is_tv_episode_already_named(filename):
    regex = chars + episode_number + opt_chars + resolution + \
        bit_depth + source + audio_ch + video_codec + encoder
    already_named = re.search(rf'{regex}', filename)
    return already_named


# MovieName.Year.{resolution}.{bit_depth}.{quality}.{source}.{audio_ch}.{video_codec}-{encoder}
def is_movie_already_named(filename):
    regex = chars + year + opt_chars + resolution + bit_depth + \
        quality + source + audio_ch + video_codec + encoder
    already_named = re.search(rf'{regex}', filename)
    return already_named


def is_movie_folder_already_named(dirname):
    regex = chars + '\(\d{4}\)'
    already_named = re.search(rf'{regex}', dirname)
    return already_named


def remove_episodes_from_list(list_to_filter):
    regex = re.compile(rf'^((?!{season_episode_number}).)*$')
    return list(filter(regex.search, list_to_filter))


def remove_special_chars(filename):
    return re.sub(rf'{special_chars}', r'', filename)
