#!/bin/sh

# From: https://gitlab.gnome.org/GNOME/gnome-builder/-/blob/main/build-aux/flatpak/fusermount-wrapper.sh

if [ -z "$_FUSE_COMMFD" ]; then
    FD_ARGS=
else
    FD_ARGS="--env=_FUSE_COMMFD=${_FUSE_COMMFD} --forward-fd=${_FUSE_COMMFD}"
fi

echo "Using FUSE communication fd: ${_FUSE_COMMFD:-none}" > /fusermount.log

exec flatpak-spawn --host --watch-bus $FD_ARGS fusermount3 "$@"
