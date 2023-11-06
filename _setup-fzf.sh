#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

SKEL=/etc/skel
readonly SKEL

readonly CMD=fzf
VERSION="$(curl --silent https://formulae.brew.sh/api/formula/${CMD}.json | jq -r '.versions.stable')"
readonly VERSION

if [[ "$(command -v $CMD)" ]]; then
    CURRENT="$("$CMD" --version | cut -d ' ' -f1)"
    readonly CURRENT
    confirm=N
    if [[ "$VERSION" == "$CURRENT" ]]; then        echo "... already the latest: ${CMD} ${CURRENT}"
    else
        echo "${CMD} ${VERSION} is available: (current ${CMD} ${CURRENT})"
        read -rp "Upgrade to ${CMD} ${VERSION}? (y/N): " confirm
    fi
fi

if [[ "${1-}" == "-f" ]] || [[ ! "$(command -v ${CMD})" ]] || [[ "$confirm" == [yY] ]]; then
    if [[ "$(uname -s)" == "Linux" ]]; then
        readonly URI="https://github.com/junegunn/fzf/archive/${VERSION}.tar.gz"
        rm -rf ~/.fzf && mkdir ~/.fzf
        wget -N "$URI"
        FILE="$(basename "$URI")"
        readonly FILE
        tar xvzf ./"$FILE" -C ~/.fzf
        sudo rm -rf "$SKEL/.fzf"
        sudo cp -r ~/.fzf "$SKEL"
        rm -f "$FILE"
        rm -rf ~/.fzf
    fi
fi
