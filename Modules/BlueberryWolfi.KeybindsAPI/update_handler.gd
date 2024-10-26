extends HBoxContainer

var _keybind_api: Node
var _action_name: String
var _default_key: InputEventKey
var _is_listening_for_input = false
var _title = ""

onready var _label = $Label
onready var _button = $Button

const LISTENING_TEXT = "..."

func _ready() -> void:
	_keybind_api = get_tree().root.get_node("BlueberryWolfiAPIs/KeybindsAPI")
	if not _keybind_api:
		push_error("KeybindAPI not found!")
		return
	
	if _button:
		_button.connect("pressed", self, "_on_button_pressed")

func setup(action_name: String, title: String, default_event: InputEventKey) -> void:
	_action_name = action_name
	_default_key = default_event
	
	_title = title
	if _label:
		_label.text = title + ":"
	
	if _button:
		_button.text = default_event.as_text()
		_button.name = action_name
		
	update_button_text(default_event.as_text())

func _on_button_pressed() -> void:
	if _is_listening_for_input:
		reset_to_default()
	else:
		start_listening()

func _input(event: InputEvent) -> void:
	if not _is_listening_for_input or not event is InputEventKey:
		return
	
	_is_listening_for_input = false
	update_button_text(event.as_text())
	_keybind_api.emit_signal("_keybind_changed", _action_name, _title, event)

func start_listening() -> void:
	_is_listening_for_input = true
	update_button_text(LISTENING_TEXT)

func reset_to_default() -> void:
	_is_listening_for_input = false
	update_button_text(_default_key.as_text())
	_keybind_api.emit_signal("_keybind_changed", _action_name, _title, _default_key)

func update_button_text(text: String) -> void:
	if _button:
		_button.text = text
