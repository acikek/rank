rank_config:
  type: data
  permissions: true
  ranks:
    default:
      name: Player
      color: <gray>
      group: player
    moderator:
      name: Moderator
      color: <dark_aqua>
      group: moderator
    admin:
      name: Admin
      color: <red>
      group: admin
    owner:
      name: Owner
      color: <gold>
      group: owner

rank_get:
  type: procedure
  definitions: id
  script:
  - determine <script[rank_config].data_key[ranks].get[<[id]>].if_null[null]>

rank_give:
  type: task
  definitions: target|id|data
  script:
  - flag <[target]> rank:<[id]>
  - group set <[data].get[group]> player:<[target]> if:<script[rank_config].data_key[permissions]>
  - customevent id:rank context:[id=<[id]>;data=<[data]>]

rank:
  type: command
  name: rank
  description: Gives a rank to a player
  usage: /rank <&lt>rank<&gt> <&lt>player<&gt>
  permission: rank.command
  tab completions:
    1: <script[rank_config].data_key[ranks].keys>
    2: <server.players.parse[name]>
  script:
  - if <context.args.is_empty>:
    - narrate "<yellow>/rank <&lt>rank<&gt> <&lt>player<&gt>"
    - narrate "<gray>If no player is specified, applies the rank to yourself."
    - stop

  - define data <context.args.first.proc[rank_get]>
  - if <[data]> == null:
    - narrate "<red>That rank doesn't exist!"
    - stop

  - if <context.args.get[2].exists>:
    - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
    - if <[target]> == null:
      - narrate "<red>That player doesn't exist!"
      - stop
  - else:
    - define target <player>

  - run rank_give def:<[target]>|<context.args.first>|<[data]>
  - narrate "<green>Gave rank <[data].get[color].parsed><[data].get[name]> <green>to <yellow><[target].name><green>."

rank_default:
  type: world
  events:
    after player joins flagged:!rank:
    - run rank_give def:<player>|default|<proc[rank_get].context[default]>