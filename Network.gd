extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var server_info = {
	name = "Server",      # Holds the name of the server
	used_port = 0         # Listening port
}

var players = {}

signal server_created
signal join_success
signal join_fail
signal player_list_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")


func create_server():
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_server(server_info.used_port) != OK):
		print("Failed to create a server")
		return
	
	get_tree().set_network_peer(net)
	emit_signal("server_created")
	register_player(Gamestate.player_info)


func join_server(ip, port):
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_client(ip, port) != OK):
		print("Failed to create a client")
		emit_signal("join_fail")
	
	get_tree().set_network_peer(net)


remote func register_player(playerInfo):
	if (get_tree().is_network_server()):
		for id in players:
			rpc_id(playerInfo.net_id, "register_player", players[id])
			if (id != 1):
				rpc_id(id, "register_player", playerInfo)
	
	print("Registering player ", playerInfo.name, " (", playerInfo.net_id, ") to internal player table")
	players[playerInfo.net_id] = playerInfo
	emit_signal("player_list_changed")


remote func unregister_player(id):
	print("Removing player ", players[id].name, " from internal table")
	players.erase(id)
	emit_signal("player_list_changed")


# Everyone gets notified whenever a new client joins the server
func _on_player_connected(id):
	pass


# Everyone gets notified whenever someone disconnects from the server
func _on_player_disconnected(id):
	print("Player ", players[id].name, " disconnected from server")
	if (get_tree().is_network_server()):
		unregister_player(id)
		rpc("unregister_player", id)


# Peer trying to connect to server is notified on success
func _on_connected_to_server():
	emit_signal("join_success")
	Gamestate.player_info.net_id = get_tree().get_network_unique_id()
	rpc_id(1, "register_player", Gamestate.player_info)
	register_player(Gamestate.playerInfo)


# Peer trying to connect to server is notified on failure
func _on_connection_failed():
	emit_signal("join_fail")
	get_tree().set_network_peer(null)


# Peer is notified when disconnected from server
func _on_disconnected_from_server():
	print("Disconnected from server")
	players.clear()
	Gamestate.player_info.net_id = 1
