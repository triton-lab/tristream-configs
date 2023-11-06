#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

readonly NAME=ffsend
readonly REPO=timvisee

VERSION="$(curl --silent https://formulae.brew.sh/api/formula/${NAME}.json | jq -r '.versions.stable')"
readonly VERSION

BINDIR=/opt/bin
readonly BINDIR

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
            "x86_64") FILE="${NAME}-v${VERSION}-linux-x64-static" ;;
            *) FILE="" ;;
        esac
        URI="https://github.com/${REPO}/${NAME}/releases/download/v${VERSION}/${FILE}"
        wget -cN -O "$NAME" "$URI"
        chmod +x "$NAME"
        sudo mkdir -p "$BINDIR"
        sudo mv -f "$NAME" "$BINDIR"
    fi
fi
