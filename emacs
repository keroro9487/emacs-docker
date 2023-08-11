#!/bin/bash

if [ "$TERM" ]; then
	ARGS="-it"
fi

parameters=()

# find out the first token not starting with "-"
for token in "$@"; do
    if [[ ! $token =~ ^- ]]; then
        # if it's a related path, convert it to absolute path
        absolute_path=$(realpath "$token")
        parameters+=("$absolute_path")
    else
        # append it to parameters
        parameters+=("$token")
    fi
done

echo "Updated parameters array: ${parameters[@]}"

docker run \
       ${ARGS:-} \
       -e DISPLAY \
       -e HOME \
       -e PATH \
       -e SHELL \
       -v /tmp:/tmp \
       -v /opt:/opt \
       -v "$HOME":"$HOME" \
       --user="$(id -u):$(id --group)" \
       ubuntu:emacs \
       "${parameters[@]}"
