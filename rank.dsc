rank_config:
  type: data
  permissions: true
  ranks:
    default:
      name: Player
      color: <green>
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
  debug: false
  definitions: id
  script:
  - determine <script[rank_config].data_key[ranks].get[<[id]>].if_null[null]>

rank_give:
  type: task
  debug: false
  definitions: user|id|data
  script:
  - flag <[user]> rank:<[id]>
  - group set <[data].get[group]> player:<[user]> if:<script[rank_config].data_key[permissions]>
  - customevent id:rank context:[id=<[id]>;data=<[data]>]

rank:
  type: command
  debug: false
  name: rank
  description: Gives a rank to a player
  usage: /rank <&lt>rank<&gt> (<&lt>player<&gt>)
  required: 1
  permission: rank.command
  tab completions:
    1: <script[rank_config].data_key[ranks].keys>
    2: <server.players.exclude[<player>].parse[name]>
  script:
  - inject cmd_args

  - define data <context.args.first.proc[rank_get]>
  - if <[data]> == null:
    - narrate "<red>That rank doesn't exist!"
    - stop

  - if <context.args.size> < 2:
    - define user <player>
  - else:
    - define user <context.args.get[2]>
    - inject cmd_player

  - run rank_give def:<[user]>|<context.args.first>|<[data]>

  - define name <[data].get[color].parsed><[data].get[name].italicize>
  - narrate "<green>Gave rank <[name]> <green>to <yellow><[user].name><green>." if:<player.equals[<[user]>].not>
  - narrate "<green>You've been given the <[name]> <green>rank!" targets:<[user]>

rank_default:
  type: world
  events:
    after player joins flagged:!rank:
    - run rank_give def:<player>|default|<proc[rank_get].context[default]>