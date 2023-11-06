#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

readonly NAME=tealdeer
readonly CMD=tldr

VERSION="$(curl --silent https://formulae.brew.sh/api/formula/${NAME}.json | jq -r '.versions.stable')"
readonly VERSION

BINDIR=/opt/bin
readonly BINDIR

CONFDIR=/etc/skel/.config
readonly CONFDIR


if [[ "$(command -v $CMD)" ]]; then
    CURRENT="$("$CMD" --version | cut -d ' ' -f2 | cut -d 'v' -f2)"
    readonly CURRENT
    confirm=N
    if [[ "$VERSION" == "$CURRENT" ]]; then        echo "... already the latest: ${NAME} ${CURRENT}"
    else
        echo "${NAME} ${VERSION} is available: (current ${NAME} ${CURRENT})"
        read -rp "Upgrade to ${NAME} ${VERSION}? (y/N): " confirm
    fi
fi

if [[ "${1-}" == "-f" ]] || [[ ! "$(command -v ${CMD})" ]] || [[ "$confirm" == [yY] ]]; then
    if [[ "$(uname -s)" == "Linux" ]]; then
        case "$(uname -m)" in
            "x86_64") FILE="tealdeer-linux-x86_64-musl" ;;
            "armv6l") FILE="tealdeer-linux-arm-musleabi" ;;
            *) FILE="" ;;
        esac
        URI="https://github.com/dbrgn/tealdeer/releases/download/v${VERSION}/${FILE}"
        wget -cN -O tldr "$URI"
        chmod +x tldr
        sudo mkdir -p "$BINDIR"
        sudo mv tldr "$BINDIR"

        sudo mkdir -p "$CONFDIR/tealdeer"
        wget -cN "https://raw.githubusercontent.com/yamaton/dotfiles/master/.config/tealdeer/config.toml"
        sudo mv config.toml "$CONFDIR/tealdeer"

        # Create cache
        sudo mkdir -p /etc/skel/.cache
        tldr --update
        sudo cp -rf ~/.cache/tealdeer /etc/skel/.cache
    fi
fi
