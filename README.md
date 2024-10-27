# Comfy APIs for WEBFISHING Mod Development

A collection of APIs designed for use in the Comfy WEBFISHING mod within GDWeave, providing streamlined management for player interactions, keybinds, and more.

## Installation

> [Download the latest release](https://github.com/BlueberryWolf/APIs/releases/latest/download/BlueberryWolfi.APIs.zip)

## Developer Usage

1. Import the downloaded source code folder into your project directory as `mods/BlueberryWolfi.APIs`.
2. Add an autoload entry in your project settings **named** `BlueberryWolfiAPIs` (no dot) to ensure that the APIs load before your mods.
3. **Important:** When exporting your project, be careful not to include the source code of these APIs.

### Code Integration

**PlayerAPI Example:**
Importing PlayerAPI
```gdscript
var _player_api: Node

func _ready():
	_player_api = get_node_or_null("/root/APIs/PlayerAPI")
```

**KeybindsAPI Example:**
Importing KeybindsAPI
```gdscript
var _keybind_api: Node

func _ready():
	_keybind_api = get_node("/root/APIs/KeybindsAPI")
```

---

## PlayerAPI

The PlayerAPI simplifies player-related tasks such as managing actors, steam IDs, and player states.

### Variables

```gdscript
PlayerAPI.local_player  # Local player as an actor
PlayerAPI.in_game       # Checks if the player is in the game
PlayerAPI.players       # List of player actors in the game
```

### Signals

```gdscript
_player_added(player)   # Triggered when a player joins, returns the player actor
_player_removed(player) # Triggered when a player leaves, returns the player actor
_ingame()               # Triggered when the local player is in-game
```

### Functions

```gdscript
is_player(node: Node) -> bool                      # Checks if a node is a Player
get_player_from_steamid(steamid: String) -> Actor  # Gets player by Steam ID
get_player_name(player: Actor) -> String           # Returns player's name
get_player_title(player: Actor) -> String          # Returns player's title
get_player_steamid(player: Actor) -> String        # Returns player's Steam ID
```

### Example Usage

```gdscript
var PlayerAPI

func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", self, "init_player")

func init_player(player: Actor):
    print(PlayerAPI.get_player_name(player))
```

---

## KeybindsAPI

The KeybindsAPI allows mods to register custom keybinds and trigger signals for input events. Configurable in the in-game controls menu.

### Signals

```gdscript
_keybind_changed(keybind: String, title: String, input_event: InputEventKey)
```

### Functions

```gdscript
register_keybind(keybind_data: Dictionary) -> String  # Registers a keybind, returns the signal name
```
*Note: A signal with "_up" appended to the signal name is automatically created for key release.*

### Example Usage

```gdscript
KeybindsAPI = get_node_or_null("/root/BlueberryWolfiAPIs/KeybindsAPI")

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

---

## Requirements

Ensure [GDWeave](https://github.com/NotNite/GDWeave) is installed to use these APIs.
