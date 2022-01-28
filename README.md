# rank

Very simple rank system

## About

A simple command and config setup that provides a Denizen rank system and interop with a permissions plugin. Players are assigned the default rank when they join for the first time. The `rank` command assigns a rank to a player, that being themselves if none is provided.

* Permissions interop can be enabled or disabled with the `permissions` config key.
* The `ranks` map consists of rank ID keys and values for display name and permission group.

## Setup

Clone using git:
```sh
git clone https://github.com/acikek/rank
```
Use [dzp](https://github.com/acikek/dzp-rs) for additional features.

### Dependencies

- [Command Utilities](https://forum.denizenscript.com/resources/command-utilities.78/)

## Scripts

### Command

- `rank`

### Data

- `rank_config`

### Procedure

- `rank_get`

### Task

- `rank_give`

### World

- `rank_default`

## License

MIT © 2022 Skye P.