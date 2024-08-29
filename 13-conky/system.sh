#!/bin/sh

echo '<span face="DejaVu Sans Mono"><span foreground="#d99f57" size="xx-large">top</span><span foreground="#78824b">'
echo ''
display-sensors 53
echo ''
LINES=16 top -b -n 1 -w
echo '</span></span>'
