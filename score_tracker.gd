extends Node
class_name ScoreTracker


var score_list: Dictionary[int,int] = {}

func add_player(id: int) -> void:
	if not score_list.has(id):
		score_list[id] = 0

func request_score_board() -> void:
	rpc("_request_score_board")

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

func _on_player_kill(id: int) -> void:
	add_kill(id)
