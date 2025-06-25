extends Label3D



#func _ready() -> void:
	#sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]

func _process(delta):
	var sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]
	var parent = get_parent();
	
	if parent.y_coord < sudoku_node.grid_stack.size():
		var grid_content = sudoku_node.grid_stack[parent.y_coord];
		text = grid_content
	else:
		text = "00"
	#if grid_content == 0:
		#text = "00"
