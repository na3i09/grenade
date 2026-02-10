extends Node
class_name ScoreTracker


var score_list: Dictionary[int,int] = {}

func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(rebuild_score_list)
		multiplayer.peer_disconnected.connect(rebuild_score_list)

func add_player(id: int) -> void:
	if not score_list.has(id):
		score_list[id] = 0

func request_score_board() -> void:
	$"../ScoreBoard/ScoreList".print_score(score_list)

func remove_player(id: int) -> void:
	if multiplayer.is_server():
		score_list.erase(id)

func rebuild_score_list() -> void:
	rpc("_rebuild_score_list",score_list)

@rpc("authority","call_remote","reliable",3)
func _rebuild_score_list(_score_list: Dictionary) -> void:
	score_list = _score_list

@rpc("any_peer","call_local","reliable",3)
func _request_score_board() -> void:
	if multiplayer.is_server():
		var id = multiplayer.get_remote_sender_id()
		rpc_id(id,"recieve_score_board",score_list)

@rpc("any_peer","call_local","reliable",3)
func recieve_score_board(_score_list: Dictionary) -> void:
	$"../ScoreBoard/ScoreList".print_score(_score_list)

func add_kill(killer_id: int) -> void:
	if score_list.has(killer_id):
		score_list[killer_id] += 1
		if multiplayer.is_server():
			rebuild_score_list()

func _on_player_kill(id: int) -> void:
	add_kill(id)
