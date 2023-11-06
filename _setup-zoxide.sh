#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

readonly NAME=zoxide

VERSION="$(curl --silent https://formulae.brew.sh/api/formula/${NAME}.json | jq -r '.versions.stable')"
readonly VERSION

BINDIR=/etc/skel/.local/bin
readonly BINDIR
sudo mkdir "$BINDIR"

MANDIR=/etc/skel/.local/share/man
readonly MANDIR


if [[ "$(command -v $NAME)" ]]; then
    CURRENT="$("$NAME" --version | cut -d ' ' -f2)"
    readonly CURRENT
    confirm=N
    if [[ "$VERSION" == "$CURRENT" ]]; then        echo "... already the latest: ${NAME} ${CURRENT}"
    else
        echo "${NAME} ${VERSION} is available: (current ${NAME} ${CURRENT})"
        read -rp "Upgrade to ${NAME} ${VERSION}? (y/N): " confirm
    fi
fi

if [[ "${1-}" == "-f" ]] || [[ ! "$(command -v ${NAME})" ]] || [[ "$confirm" == [yY] ]]; then
    if [[ "$(uname -s)" == "Linux" ]]; then
        case "$(uname -m)" in
            "x86_64")  readonly FILE="${NAME}-${VERSION}-x86_64-unknown-linux-musl.tar.gz" ;;
            "armv7l")  readonly FILE="${NAME}-${VERSION}-armv7-unknown-linux-musleabihf.tar.gz" ;;
            "aarch64") readonly FILE="${NAME}-${VERSION}-aarch64-unknown-linux-musl.tar.gz" ;;
        esac

        readonly URI="https://github.com/ajeetdsouza/zoxide/releases/download/v${VERSION}/${FILE}"
        wget -cN "$URI"
        readonly DIRNAME="${FILE%.*.*}"
        mkdir -p "$DIRNAME"
        tar -xvf "$FILE" --directory "$DIRNAME"
        rm -f "$FILE"
        mv -f "${DIRNAME}/${NAME}" "$BINDIR"

        # save man files
        sudo mkdir -p "$MANDIR/man1"
        mv "${DIRNAME}"/man/man1/*.1 "$MANDIR/man1"
        mandb "$MANDIR/man1"
        rm -rf "$DIRNAME"
    fi
fi
