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
	show_ip_address_input()

func show_ip_address_input() -> void:
	$MainMenu/LineEdit.visible = true
	$MainMenu/LineEdit.grab_focus()

func show_respawn_button() -> void:
	Input.set_mouse_mode.call_deferred(Input.MOUSE_MODE_CONFINED) #TODO: fix NO GRAB error that occurs if calling while window is unfocued
	$RespawnMenu.show()

func add_player(id = 1):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	add_child.call_deferred(player,true)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer","call_local")
func _del_player(id):
	if multiplayer.is_server():
		get_node(str(id)).queue_free()

func respawn_player(id):
	rpc("_respawn_player",id)

@rpc("any_peer","call_local")
func _respawn_player(id):
	if multiplayer.is_server():
		add_player(id)

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

func _on_respawn_pressed() -> void:
	$RespawnMenu.hide()
	respawn_player(multiplayer.get_unique_id())
