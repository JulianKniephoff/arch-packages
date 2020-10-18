#!/bin/sh

# TODO Make this script more testable locally
#   The user stuff needs to go, for example

# TODO Make this an action?

set -o errexit

export PKGDEST="$GITHUB_WORKSPACE/repo"

# TODO Isn't there some kind of convenient wrapper for this?
# TODO This will break paths with newlines
#   We could use `-d ''` with `-print0`,
#   but see below, and also this is not POSIX sh compatible
find "$PWD" -name PKGBUILD | while IFS= read -r pkg
do
    # TODO Be explicit about the home directory?
    cd /home/builder
    pkg="$(dirname "$pkg")"
    cp -a "$pkg" .
    pkg="$(basename "$pkg")"
    chown -R builder "$pkg"
    cd "$pkg"

    build=yes
    # TODO Is this necessary as well? See https://bugs.archlinux.org/task/63092
    #makepkg -dd --nobuild # hopefully no prepare function runs commands that don't exist yet
    pkgs="$(sudo -u builder makepkg --packagelist)"
    # TODO This breaks with newline in the path, I think
    while IFS= read -r pkg
    do
        if [ -f "$pkg" ]
        then
            build=no
        fi
    done <<EOF
$pkgs
EOF
    # TODO Can you somehow indent the above?
    #   Maybe with `<<-` but that only works on tabs ...
    #   So do we have to use tabs here?
    #   Or you could use a FIFO
    #   Or bash

    if [ $build = yes ]
    then
        # TODO Okay shit, now this wants to install packages
        # TODO Do the "Custom" thing here: https://www.vultr.com/docs/using-devtools-on-arch-linux
        # TODO Can you somehow get rid of the progress bars?
        # TODO Is it still necessary that we create the chroot in the workspace? here?
        #   I mean maybe we can cache it that way
        # TODO This does not check whether the package already exists ...
        # TODO Why does `noprogressbar` not work?
        #   It does for parts of the command ...
        extra-x86_64-build -r "$GITHUB_WORKSPACE/chroot" -- -U builder -- --noprogressbar
    fi
done
