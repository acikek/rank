rank_config:
  type: data
  permissions: true
  ranks:
    default:
      name: <gray>Player
      group: player
    moderator:
      name: <dark_aqua>Moderator
      group: moderator
    admin:
      name: <red>Admin
      group: admin
    owner:
      name: <gold>Owner
      group: owner

rank_give:
  type: task
  definitions: target|name|data
  script:
  - flag <[target]> rank:<[name]>
  - group set <[data].get[group]> player:<[target]> if:<script[rank_config].data_key[permissions]>
  - customevent id:rank context:[id=<[name]>;data=<[data]>]

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

  - define rank <script[rank_config].data_key[ranks].get[<context.args.first>].if_null[null]>
  - if <[rank]> == null:
    - narrate "<red>That rank doesn't exist!"
    - stop

  - if <context.args.get[2].exists>:
    - define target <server.match_offline_player[<context.args.get[2]>].if_null[null]>
    - if <[target]> == null:
      - narrate "<red>That player doesn't exist!"
      - stop
  - else:
    - define target <player>

  - run rank_give def:<[target]>|<context.args.first>|<[rank]>
  - narrate "<green>Gave rank <[rank].get[name].parsed> <green>to <yellow><[target].name><green>."

rank_default:
  type: world
  events:
    after player joins flagged:!rank:
    - run rank_give def:<player>|default|<script[rank_config].data_key[ranks].get[default]>