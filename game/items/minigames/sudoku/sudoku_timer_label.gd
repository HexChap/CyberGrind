extends Label3D



func _process(delta):
	var sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]
	var time: int = sudoku_node.time
	var time_mins = time / 60
	var time_secs= time % 60
	var time_secs_str: String = ""
	if time_secs < 10:
		time_secs_str = "0" + str(time_secs)
	else:
		time_secs_str = str(time_secs)
	
	text = str(str(time_mins) + ":" + time_secs_str)
	
