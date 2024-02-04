# head47/Incognita-Socket

This is a fork of the [Incognita Socket](https://github.com/Cyberboy2000/Incognita-Socket) mod with additional improvements, mostly to Backstab Protocols, to make it more playable in co-op scenarios with multiple players.

The eventual goal for these changes is to merge them into upstream, but for the time being, they are here.

## Contact

Feature suggestions, bug reports, and especially pull requests are welcome! I'm still figuring out most of IS's code, and so any help would be greatly appreciated.

You can reach me at the II Discord server: https://discord.gg/dBUCcfcbdk

## Changes

Compared to Cyberboy2000's version:
* 1 Player = 1 Agent mode. If enabled, host will be able to assign an agent to each player, and players won't be able to act as others' agents. This mode is described in detail [here](docs/1P1A.md)
* Player cannot rewind when it is another player's turn (fixes the infinite rewinds bug)
* When it becomes your turn in BP, the "Warning" sound plays, and the "%PLAYER%'S TURN" ribbon becomes yellow instead of blue
* Autoyielding: pressing the End Turn button when it is not your turn in BP will make you yield turns until after the next corporation's turn
* If you try to act while it is another player's turn, a "Not your turn" warning will be displayed
* End Turn button now changes its tooltip depending on its status
* Option: no longer require performing costly actions to yield turn in BP. This allows for a more relaxed co-op experience where "turn juggling" is acceptable
