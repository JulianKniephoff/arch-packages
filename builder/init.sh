#!/bin/sh

pacman -Syu --noprogress --noconfirm

exec "$@"
