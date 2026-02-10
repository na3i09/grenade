extends ItemList
class_name ScoreList

var score_dict: Dictionary[int,int] = {}


func _on_visibility_changed() -> void:
	if visible:
		$"../../ScoreTracker".request_score_board()

func print_score(score_list) -> void:
	clear()
	for i in score_list.keys():
		add_item(str(i) + ": " + str(score_list[i]))
