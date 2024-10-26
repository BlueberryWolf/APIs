extends Node

signal _keybind_changed(keybind, title, input_event)

const ButtonScene = preload("res://mods/BlueberryWolfi.Apis/Modules/BlueberryWolfi.KeybindsAPI/Scenes/button.tscn")

var PlayerAPI

var _keybinds: Array = []
var _signals: Array = []
var _ui_keybinds: Dictionary = {}
var _is_initialized: bool = false
var controls_container: VBoxContainer

func _ready() -> void:
	PlayerAPI = get_tree().root.get_node("BlueberryWolfiAPIs/PlayerAPI")
	var options_menu = get_node_or_null("/root/OptionsMenu")
	if not options_menu:
		push_error("OptionsMenu not found!")
		return
		
	controls_container = options_menu.get_node("Control/Panel/tabs_main/control/ScrollContainer/HBoxContainer/VBoxContainer")
	
	connect("_keybind_changed", self, "_on_keybind_changed")
	pass

func _input(event: InputEvent) -> void:
	if not PlayerAPI.local_player: return
	if not event is InputEventKey or PlayerAPI.local_player.busy:
		return
	
	for keybind in _keybinds:
		if not InputMap.has_action(keybind.action_name):
			continue

		if event.is_action_pressed(keybind.action_name):
			emit_signal(keybind.signal_name)
		elif event.is_action_released(keybind.action_name):
			emit_signal(keybind.signal_name + "_up")

func register_keybind(keybind_data: Dictionary) -> String:
	var keybind = {
		"action_name": keybind_data.action_name,
		"key": keybind_data.key,
		"signal_name": keybind_data.get("signal_name", keybind_data.action_name),
		"title": keybind_data.get("title", keybind_data.action_name),
	}
	
	_cleanup_existing_keybind(keybind)
	_register_input_action(keybind)
	_register_signals(keybind)
	if not _ui_keybinds.has(keybind.action_name):
		_keybinds.append(keybind)
	_create_or_update_ui(keybind)
	
	return keybind.signal_name

func _cleanup_existing_keybind(keybind: Dictionary) -> void:	
	InputMap.action_erase_events(keybind.action_name)

func _register_input_action(keybind: Dictionary) -> void:
	var input_event = InputEventKey.new()
	input_event.set_scancode(keybind.key)
	
	if not InputMap.has_action(keybind.action_name):
		InputMap.add_action(keybind.action_name)
	InputMap.action_add_event(keybind.action_name, input_event)
		
func _register_signals(keybind: Dictionary) -> void:
	if not has_user_signal(keybind.signal_name):
		add_user_signal(keybind.signal_name)
	if not has_user_signal(keybind.signal_name + "_up"):
		add_user_signal(keybind.signal_name + "_up")
	if not _signals.has(keybind.signal_name):
		_signals.append(keybind.signal_name)

func _create_or_update_ui(keybind: Dictionary) -> void:
	var key_node: Node
	
	if not _ui_keybinds.has(keybind.action_name):
		key_node = ButtonScene.instance()
		key_node.name = keybind.action_name
		
		controls_container.add_child(key_node)
		_ui_keybinds[keybind.action_name] = key_node
	else:
		key_node = _ui_keybinds[keybind.action_name]
	
	var input_event = InputEventKey.new()
	input_event.set_scancode(keybind.key)
	key_node.setup(keybind.action_name, keybind.title, input_event)

func _on_keybind_changed(action_name: String, title: String, input_event: InputEvent) -> void:
	if action_name == null:
		return
	
	register_keybind({
		"action_name": action_name,
		"title": title,
		"key": input_event.scancode,
	})
