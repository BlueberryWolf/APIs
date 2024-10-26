# BlueberryWolfi.APIs
APIs for Comfy WEBFISHING Mod Development in GDWeave

I am too exhausted to make a proper usage docs but here are some basic usage examples to reference for now:

# Player API:
## An API that makes everything to do with players, actors, and steamids easier.
### Variables:
```gd
PlayerAPI.local_player # local player as an actor
PlayerAPI.in_game # player is in game
PlayerAPI.players # list of Player Actors in the game
```
### Signals:
```gd
_player_added(player) # returns player actor on game join
_ingame() # locaL player is in game
```
### Functions:
```gd
is_player(node: Node) -> bool # is node a Player?
get_player_from_steamid(steamid: String) -> Actor # returns provided 
get_player_name(player: Actor) -> String # returns player name
get_player_title(player: Actor) -> String # returns player title
get_player_steamid(player: Actor) -> String # returns player's steam id
```

### Code Example:
```gd
var PlayerAPI

func _ready():
	PlayerAPI = get_node("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", self, "init_player")

func init_player(player: Actor)
  print(PlayerAPI.get_player_name(player)
```
# Keybinds API:
## An API that allows mods to register keybinds, and subscribe to a custom signal for input events. Then, mod controls can be configured in the in-game controls menu.
### Signals:
```gd
_keybind_changed(keybind: String, title: String, input_event: InputEventKey)
```
### Functions:
```gd
register_keybind(keybind_data: Dictionary) -> String # returns signal_name
# Register keybind automatically registers a keybind, and returns the name of the signal. It also automatically creates another signal with the signal name, with "_up" appended for key release
```

### Code Example:
```gd
var pushtalk_mic_signal = KeybindAPI.register_keybind({
  "action_name": "toggle_ptt",
  "title": "Toggle Push to Talk",
  "key": KEY_T,
})

KeybindAPI.connect(pushtalk_mic_signal, self, "_on_to_talk_button_down")
KeybindAPI.connect(pushtalk_mic_signal + "_up", self, "_on_to_talk_button_up")

func _on_to_talk_button_down() -> void:
  print("Push to talk on")

func _on_to_talk_button_up() -> void:
  print("Push to talk off")
```
requires:
https://github.com/NotNite/GDWeave
