#!/usr/bin/env python3
import sys
import json

def main():
    with open('/tmp/waybarpowerstate', 'r') as f:
        state = f.read() or 'shutdown'
    for dual in {'shutdown', 'reboot'} - {state}:
        with open('/tmp/waybarpowerstate', 'w') as f:
            f.seek(0)
            f.write(dual)
        output = {'text': {'shutdown': '󰐥', 'reboot': ''}[dual], 'alt': dual}
        sys.stdout.write(json.dumps(output) + '\n')
        sys.stdout.flush()
        break

if __name__ == '__main__':
    main()
