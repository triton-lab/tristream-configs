#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

readonly CMD=tre
readonly NAME=tre-command

VERSION="$(curl --silent https://formulae.brew.sh/api/formula/${NAME}.json | jq -r '.versions.stable')"
readonly VERSION

BINDIR=/opt/bin
readonly BINDIR

MANDIR=/etc/skel/.local/share/man
readonly MANDIR

mkdirmv () {
    mkdir -p "$2" && mv -f "$1" "$2"
}

if [[ "$(command -v $CMD)" ]]; then
    CURRENT="$("$CMD" --version | cut -d ' ' -f 2)"
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
        case "$(uname -m)" in
            "x86_64")  readonly URL="https://github.com/dduan/tre/releases/download/v${VERSION}/tre-v${VERSION}-x86_64-unknown-linux-musl.tar.gz" ;;
        esac
        echo "URL=$URL"
        wget -N "$URL"
        FILE="$(basename "$URL")"
        tar -xvf "$FILE"
        sudo mkdir -p "$BINDIR"
        sudo mkdir -p "$MANDIR/man1"
        sudo mv -f "$CMD" "$BINDIR"
        sudo mv -f "$CMD.1" "$MANDIR/man1"
        mandb "$MANDIR"
        rm -rf "$FILE"
    fi
fi
