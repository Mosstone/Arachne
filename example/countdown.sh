#!/usr/bin/env bash






i=15
echo
while [ $i -gt 0 ]; do
    printf '[94m\r'%s "    $i "
    ((--i))
    sleep 1
done

printf '\r'%s '    🎉'
read -r
