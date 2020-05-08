#!/bin/bash
binaries=(make curl jq docker kubectl helm stern)
requirements_ok=true
for i in "${binaries[@]}"; do
    if [[ -z $(type -t $i) ]]
    then
        echo "$i not installed. Please install it before proceed."
        requirements_ok=false
    fi
done
if [ "$requirements_ok" = true ]; then printf "All system requirements meet.\n"; fi
