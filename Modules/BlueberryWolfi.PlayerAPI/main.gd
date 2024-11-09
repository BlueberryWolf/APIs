extends Node
signal _player_added(player)
signal _player_removed(player)
signal _ingame()

var players = []
var in_game = false
var local_player
var entities

func _ready():
	get_tree().connect("node_added", self, "_player_ready")
	
func _player_ready(node: Node):
	var map: Node = get_tree().current_scene
	in_game = map.name == "world"

	if node.name != "main_map": return
	if not in_game: return
	entities = get_tree().current_scene.get_node("Viewport/main/entities")
	
	print("playerAPI init")
	# add playerAPI child node with injectedMain.gd script to player
	
	entities.connect("child_entered_tree", self, "player_added")

func is_player(node: Node) -> bool:
	return node.name == "player" or node.name.begins_with("@player@")

func get_player_from_steamid(steamid: String):
	for actor in players:
		if int(actor.owner_id) == int(steamid):
			return actor

func get_player_name(player: Actor):
	if not is_player(player): return null
	return player.get_node("Viewport/player_label").label

func get_player_title(player: Actor):
	if not is_player(player): return null
	return player.get_node("Viewport/player_label").title

func get_player_steamid(player: Actor):
	if not is_player(player): return null
	return player.owner_id
	
func player_removed(node):
	if node.name == "player":
		local_player = null
	emit_signal("_player_removed", node)
	
func player_added(node):
	if node.name == "player":
		local_player = node
		players.append(node)
		yield(get_tree().create_timer(0.5), "timeout")
		emit_signal("_ingame")
	elif node.name.begins_with("@player@"):
		players.append(node)
	else: return
	
	connect("tree_exited", node, "player_removed")
	# wait 0.5 seconds to ensure player is properly initialized
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("_player_added", node)
