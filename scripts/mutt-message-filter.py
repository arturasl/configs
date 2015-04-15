#!/usr/bin/env python3

import sys, email, os, re, unicodedata

full_message = sys.stdin.read()
sys.stdout.write(full_message)

parsed_email = email.message_from_string(full_message)

# extract headers
addresses = email.utils.getaddresses(parsed_email.get_all('to', [])
                    + parsed_email.get_all('from', [])
                    + parsed_email.get_all('cc', [])
                    + parsed_email.get_all('bcc', []))

# decode
def decode_header(hdr):
    de = email.header.decode_header(hdr)
    return ''.join(el[0] if not el[1] else el[0].decode(el[1]) for el in de)
addresses = [tuple(decode_header(e) for e in addr) for addr in addresses if addr]
# normalize emails/names and remove anything that do not looks like an email
addresses = [(re.sub('[\'"]', '', addr[0].title()), addr[1].lower()) for addr in addresses if '@' in addr[1]]
# add alias names
addresses = [
        (
            re.sub(r'[^a-z_.0-9]',
                '',
                unicodedata
                    .normalize('NFKD', addr[0])
                    .encode('ascii', 'ignore')
                    .decode('ascii')
                    .replace(' ', '.')
                    .lower() if addr[0] else addr[1].split('@')[0])
            , addr[0]
            , addr[1]
        )
        for addr in addresses]

alias_file = os.path.expanduser('~/Dropbox/configs/mutt/mutt-alias')
# remove addresses that are in alias file
with open(alias_file, 'r') as aliasses_fp:
    for line in aliasses_fp:
        if line and line[0] != '#':
            addresses = [addr for addr in addresses if addr[2] not in line]

# append new addreses
if addresses:
    with open(alias_file, 'a') as aliasses_fp:
        for addr in addresses:
            aliasses_fp.write('alias {}\n'.format(' '.join(addr)))
