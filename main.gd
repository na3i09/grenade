extends Node3D

var peer = ENetMultiplayerPeer.new()

const PORT: int = 1027

@export var PlayerScene: PackedScene

@export var GrenadeScene: PackedScene

func _on_host_button_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	
	$MainMenu.hide()

func _on_client_button_pressed() -> void:
	#peer.create_client("127.0.0.1",PORT)
	#multiplayer.multiplayer_peer = peer
	#
	#$MainMenu.hide()
	
	show_ip_address_input()

func show_ip_address_input() -> void:
	$MainMenu/LineEdit.visible = true
	$MainMenu/LineEdit.grab_focus()
	
	

func add_player(id = 1):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	add_child.call_deferred(player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()

func throw_grenade(pos: Vector3,vel: Vector3):
	rpc("_throw_grenade",pos,vel)

@rpc("any_peer","call_local")
func _throw_grenade(pos: Vector3,vel: Vector3):
	var grenade = GrenadeScene.instantiate()
	
	grenade.starting_velocity = vel
	
	add_child(grenade)
	
	grenade.global_position = pos

func _on_line_edit_text_submitted(new_text: String) -> void:
	peer.create_client(new_text,PORT)
	multiplayer.multiplayer_peer = peer
	
	$MainMenu.hide()
