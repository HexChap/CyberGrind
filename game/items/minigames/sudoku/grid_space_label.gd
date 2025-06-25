extends Label3D



#func _ready() -> void:
	#sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]

func _process(delta):
	var sudoku_node = get_tree().get_nodes_in_group("SudokuRoot")[0]
	var parent = get_parent();
	var grid_content = sudoku_node.grid[parent.coord.x][parent.coord.y];
	text = grid_content
	#if grid_content == 0:
		#text = "00"
