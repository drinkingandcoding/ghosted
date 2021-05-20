extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("server_created", self, "_on_ready_to_play")
	Network.connect("join_success", self, "_on_ready_to_play")
	Network.connect("join_fail", self, "_on_join_fail")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ServerCreate_pressed():
	set_player_info()

	if (!$PanelHost/ServerName.text.empty()):
		Network.server_info.name = $PanelHost/ServerName.text
	Network.server_info.used_port = int($PanelHost/ServerPort.text)
	
	Network.create_server()


func _on_ready_to_play():
	get_tree().change_scene("res://Main.tscn")


func _on_join_fail():
	print("Failed to join server")


func _on_JoinButton_pressed():
	set_player_info()

	var port = int($PanelJoin/JoinPort.text)
	var ip = $PanelJoin/JoinIP.text
	Network.join_server(ip, port)


func set_player_info():
	if (!$PanelPlayer/PlayerName.text.empty()):
		Gamestate.player_info.name = $PanelPlayer/PlayerName.text
