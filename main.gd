extends Node3D

signal player_kill(killer_id: int)

var peer = ENetMultiplayerPeer.new()

const PORT: int = 1027

@export var PlayerScene: PackedScene

@export var weapon_array: Array[Weapon]

@onready var grenade_dict: Dictionary[int,Weapon] = Weapon.generate_weapon_dict(weapon_array)

var player_name_dict: Dictionary[int,String] = {}

var first_names: PackedStringArray = ["Grandor","Kaltos","Bazelus","Rangto","Ingzar","Wizka"]

var titles: PackedStringArray = ["Indominable","Clever","Purple","Wise"]

var adjectives: PackedStringArray = ["Great","Peerless","incompetent","Nimble","Unstoppable"]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	if event.is_action_pressed("show_score"):
		toggle_scoreboard()

func toggle_scoreboard() -> void:
	if $ScoreBoard.visible:
		$ScoreBoard.hide()
	else:
		$ScoreBoard.show()


func _on_host_button_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect($ScoreTracker.remove_player)
	add_player()
	multiplayer.peer_connected.connect($ScoreTracker.rebuild_score_list_on_peer_change)
	multiplayer.peer_disconnected.connect($ScoreTracker.rebuild_score_list_on_peer_change)
	
	$MainMenu.hide()

func _on_client_button_pressed() -> void:
	show_ip_address_input()

func show_ip_address_input() -> void:
	$MainMenu/LineEdit.visible = true
	$MainMenu/LineEdit.grab_focus()

func show_respawn_button() -> void:
	Input.set_mouse_mode.call_deferred(Input.MOUSE_MODE_CONFINED) #TODO: fix NO GRAB error that occurs if calling while window is unfocued
	$RespawnMenu.show()

func generate_player_name() -> String:
	return pick_name(adjectives) + " " + pick_name(first_names) + " the " + pick_name(titles)

func pick_name(list: PackedStringArray) -> String:
	return list[randi() % list.size()]

func add_player(id = 1):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	player.display_name = generate_player_name()
	player_name_dict[id] = player.display_name
	if multiplayer.is_server():
		$ScoreTracker.add_player(id)
		update_player_dict()
	add_child.call_deferred(player,true)

func update_player_dict() -> void:
	rpc("_update_player_dict",player_name_dict)

@rpc("authority","call_remote")
func _update_player_dict(name_dict: Dictionary[int,String]) -> void:
	player_name_dict = name_dict

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player",id)

## deletes player with the matching id, and optionally attributes a kill to the player under killer_id
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

func throw_grenade(type: int,pos: Transform3D,vel: Vector3):
	rpc("_throw_grenade",type,pos,vel)

@rpc("any_peer","call_local")
func _throw_grenade(type:int,pos: Transform3D,vel: Vector3):
	var grenade = grenade_dict[type].ProjectileScene.instantiate()
	
	grenade.assign_starting_velocity(vel)
	grenade.originator_id = multiplayer.get_remote_sender_id()
	add_child(grenade)
	
	grenade.global_transform = pos

func _on_line_edit_text_submitted(new_text: String) -> void:
	peer.create_client(new_text,PORT)
	multiplayer.multiplayer_peer = peer
	
	$MainMenu.hide()

func _on_respawn_pressed() -> void:
	$RespawnMenu.hide()
	respawn_player(multiplayer.get_unique_id())

func register_kill(killer_id: int) -> void:
	rpc_id(1,"_register_kill",killer_id)

@rpc("any_peer","call_local","reliable",3)
func _register_kill(killer_id: int) -> void:
	player_kill.emit(killer_id)

func detonate_sachels() -> void:
	rpc("_detonate_sachels")

@rpc("any_peer","call_local")
func _detonate_sachels() -> void:
	var id = multiplayer.get_remote_sender_id()
	get_tree().call_group("Sachels","trigger_remote",id)
