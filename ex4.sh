#!/bin/bash
FILE="$HOME/etc/hosts"

verify-IP() {
    local ip_from_file="$1"
    local hostname="$2"
    local real_ip

    real_ip=$(nslookup "$hostname" | grep "Address:" | tail -n1 | cut -d ' ' -f 2)

    if [ -z "$real_ip" ]; then
        echo "Eroare: nslookup nu a gasit un IP pentru '$hostname'" >&2
        return 1
    fi

    if [ "$ip_from_file" != "$real_ip" ]; then
        echo "Bogus IP for <$hostname> in $HOME/etc/hosts !"
        return 2
    else
      
        echo "OK: $hostname ($ip_from_file)"
        return 0
    fi
}



while read -r ip_din_fisier nume_host _; do
    verify-IP "$ip_din_fisier" "$nume_host"
done < <(grep -vE "^#|^$" "$FILE")

