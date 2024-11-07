extends Node

const PREFIX = "BlueberryWolfi"

const MODULES_LIST = {
	"PlayerAPI":   preload("res://mods/BlueberryWolfi.APIs/Modules/BlueberryWolfi.PlayerAPI/main.gd"),
	"KeybindsAPI": preload("res://mods/BlueberryWolfi.APIs/Modules/BlueberryWolfi.KeybindsAPI/main.gd")
}

var modules = {}

func _ready():
	for module in MODULES_LIST:
		var resource = MODULES_LIST[module]
		
		modules[module] = resource.new()
		modules[module].set_name(module.replace(PREFIX, ""))
		add_child(modules[module])
