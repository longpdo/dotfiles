from termcolor import colored


def print_err(msg):
    print(colored(msg, 'red'))


def print_exit(msg):
    print(colored(msg, 'white'))


def print_log(msg):
    print(colored(msg, 'yellow'))


def print_ok(msg):
    print(colored(msg, 'green'))
