#!/usr/bin/env python3
# Credit: https://github.com/3m4r5/dotfiles/blob/main/scripts/keybinds.py
import json
import os
import subprocess
from typing import TypedDict


class Keybind(TypedDict):
    key: str
    dispatcher: str
    arg: str
    modmask: int


MODIFIERS = {
    0: "󰘶",
    1: "󰌎",
    2: "󰘴",
    3: "󰘵",
    6: "󰨡"
}
DIGITS = "1023456789"


def format_modifiers(mask: int) -> str:
    """Convert a modifier bitmask into an icon string."""
    bits = f"{mask:b}".zfill(7)[::-1]
    return " + ".join(
        icon for bit, icon in MODIFIERS.items() if bits[bit] == "1"
    )


def get_keybinds() -> list[Keybind]:
    """Fetch keybinds from hyprctl as a list of dicts."""
    output = subprocess.check_output(
        ["hyprctl", "binds", "-j"], text=True
    )
    return json.loads(output)


def filter_keybinds(bindings: list[Keybind]) -> list[Keybind]:
    """Filter out redundant keybinds."""
    filtered: list[Keybind] = []
    last_arg = last_dispatcher = ""

    for bind in bindings:
        key = bind["key"]
        dispatcher = bind["dispatcher"]
        arg = bind["arg"]

        # Skip duplicate digit-only bindings with same dispatcher
        if all([
            arg in DIGITS,
            last_arg in DIGITS,
            key in DIGITS,
            dispatcher == last_dispatcher,
        ]):
            continue

        last_arg = arg
        last_dispatcher = dispatcher

        new_bind = bind.copy()
        if new_bind["arg"] == new_bind["key"][0]:
            new_bind["arg"] = new_bind["key"]

        filtered.append(new_bind)

    return filtered


def format_tooltip(bindings: list[Keybind]) -> str:
    """Build tooltip string from already-filtered keybindings."""
    tooltip = ["<b>Keybinds:</b>"]

    for i, bind in enumerate(bindings, start=1):
        mods = format_modifiers(bind["modmask"])
        key = bind["key"]
        dispatcher = bind["dispatcher"]
        arg = bind["arg"]

        if arg in DIGITS and key in DIGITS:
            key = arg = '#'

        entry = f"{i}: {mods}{key}: {dispatcher} {arg}"
        entry = entry.replace("&", "&amp;")
        tooltip.append(entry)

    return "\n".join(tooltip)


def main():
    bindings = get_keybinds()
    filtered = filter_keybinds(bindings)
    tooltip = format_tooltip(filtered)
    data = {"tooltip": tooltip}

    if os.getenv("DEBUG_JSON") == "1":
        print(json.dumps(data, indent=2))
    else:
        print(json.dumps(data))


if __name__ == "__main__":
    main()
