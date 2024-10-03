#!/usr/bin/env bash

[ "$(wl-paste)" == "" ] && echo "clipboard is empty" || echo "clipboard: $(wl-paste)"