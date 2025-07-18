#!/usr/bin/env bash


readarray -t wisdom < <(jq -r '.say[]' "$(dirname ${BASH_SOURCE[0]})/wisdom.json")


println() {
    i="${#wisdom[1]}"
    while [[ $i -ge 0 ]]; do
        echo -n '_'
        ((--i))
    done
    echo
}


prindash() {
    i="${#wisdom[1]}"
    while [[ $i -ge 0 ]]; do
        echo -n '-'
        ((--i))
    done
    echo
}


cat <<-EOF
    [94m __$(println)_
    [94m/  $(echo "${wisdom[0]}")  \\
$(for line in "${wisdom[@]:1:${#wisdom[@]}-2}"; do
    echo "    |  $line  |"
done)
    [94m\\  $(echo "${wisdom[-1]}")  /
    [94m --$(prindash)-
    [94m        \\   ^__^
    [94m         \\  (oo)\\_______
    [94m            (__)\\       )\\/\\
    [94m                ||----w |
    [94m                ||     ||
[94m$(println)__________
EOF
