#!/bin/env python3

import os, sys

command="#!/bin/bash\n/usr/bin/miner --algo 144_5 --pers BgoldPoW --server asia-btg.2miners.com --port 4040 --user GKxLMr5TurGosUYjK3TeJVkaT2D6Uf2Whu.{}"

def get_miner_name():
    with open('/big_command.sh') as f:
        content = f.read()
        for idx, c in reversed(list(enumerate(content))):
            if c == '.':
                return content[idx+1:].strip()

def save_command(id):
    with open('/big_command.sh', 'w') as f:
        f.write(command.format(id))

if __name__ == "__main__":
    print("\n\nWorker stdout:") # for sudo
    id = sys.argv[1]
    miner_name = get_miner_name()
    host_name = os.uname()[1]
    print('MinerName({}) | HostName({})'.format(miner_name, host_name))

    print('Setting hostname to {}'.format(id))
    with open('/etc/hostname', 'w') as f:
        f.write(id + '\n')

    with open('/etc/hosts', 'r+') as f:
        lines = f.readlines()
        f.seek(0)
        for line in lines:
            if '127.0.1.1' in line:
                f.write('127.0.1.1\t' + id + '\n')
            else:
                f.write(line)
        f.truncate()


    os.system('systemctl restart avahi-daemon')

    save_command(id)
    print('Rebooting...')
    os.system('reboot')
