#!/bin/bash


NUM_PACKETS=$1
HOSTNAME=$2


export LANG=C
PING_OUTPUT=$(ping -c "$NUM_PACKETS" "$HOSTNAME")

TIME_VALUES=$(echo "$PING_OUTPUT" | grep "icmp_seq" | cut -d '=' -f 4 | cut -d ' ' -f 1)


if [ -z "$TIME_VALUES" ]; then
    echo "nu am primit raspuns"
    exit 3
fi


min=""
max="0"
sum="0"
count=0

for time in $TIME_VALUES
do
  
    if [ -z "$min" ]; then
        min=$time
    fi

    if (( $(echo "$time < $min" | bc -l) )); then
        min=$time
    fi

    if (( $(echo "$time > $max" | bc -l) )); then
        max=$time
    fi

    sum=$(echo "$sum + $time" | bc -l)
    count=$((count + 1))
done

average=$(echo "scale=3; $sum / $count" | bc -l)


echo ""
echo "ce a scos scriptul"
echo "tminim:   $min ms"
echo "tmaxim:   $max ms"
echo "tmediu:   $average ms"
echo ""

ping_sum=$(echo "$PING_OUTPUT" | grep "rtt")

echo "sumar pentru comp"
echo "$ping_sum"
