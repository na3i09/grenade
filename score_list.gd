extends ItemList
class_name ScoreList

var score_dict: Dictionary[int,int] = {}

var first_list: bool = true

func _on_visibility_changed() -> void:
	if first_list:
		$"../../ScoreTracker".rpc("_request_score_board")
		first_list = false
	if visible:
		$"../../ScoreTracker".request_score_board()

func print_score(score_list) -> void:
	clear()
	for i in score_list.keys():
		add_item(Globals.player_name_dict[i] + ": " + str(score_list[i]))
