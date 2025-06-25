extends Label3D



func _process(delta):
	var sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]
	var rollbacks: int = sudoku_node.score
	
	text = str(rollbacks)
	
