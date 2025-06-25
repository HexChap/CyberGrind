extends Node3D

@export var percent_empty = 0.6;
@export var grid: Array;
@export var grid_stack: Array;

func _ready():
	add_to_group("SudokuRoot")
	_regenerate()
	for row in grid:
		print(row)


func _process(delta):
	pass

func remove_random_slots(percent: float, grid: Array) -> void:
	var size := grid.size()
	var total_cells := size * size
	var amount := int(round(total_cells * percent))
	var deleted := 0

	while deleted < amount:
		var row := randi_range(0, size - 1)
		var col := randi_range(0, size - 1)
		if grid[row][col] == ".":
			continue
		grid_stack.append(grid[row][col])
		grid[row][col] = "."
		deleted += 1
	
	print(grid_stack)

func play_sudoku(x: int, y: int) -> bool:
	if grid[x][y] != ".":
		return false
	var valid = _is_valid(grid, x, y, grid_stack[0])
	if not valid:
		return false
	
	grid[x][y] = grid_stack[0]
	grid_stack.pop_front()
	if _check_if_softlocked():
		_regenerate()
	
	print(grid_stack)
	return true

func _generate_diagonal_arr() -> Array:
	var size := 4
	var box_size := 2  # since sqrt(4) = 2
	var grid: Array = []

	# 1) create empty grid
	for i in range(size):
		grid.append([".", ".", ".", "."])

	# 2) fill each diagonal box
	for box_idx in range(box_size):
		# create a random permutation of 1..4
		var nums := [1, 2, 3, 4]
		nums.shuffle()

		var start_row := box_idx * box_size
		var start_col := box_idx * box_size
		var idx := 0

		for i in range(start_row, start_row + box_size):
			for j in range(start_col, start_col + box_size):
				grid[i][j] = str(nums[idx])
				idx += 1

	return grid


func _solve(board: Array) -> bool:
	for row in range(4):
		for col in range(4):
			if board[row][col] == ".":
				for num in range(1, 5):  # 1 to 4 inclusive
					var char: String = str(num)
					if _is_valid(board, row, col, char):
						board[row][col] = char
						if _solve(board):
							return true
						board[row][col] = "."  # Backtrack
				return false  # No valid number worked
	return true  # Board is fully solved

func _is_valid(board: Array, row: int, col: int, char: String) -> bool:
	# Check row and column
	for i in range(4):
		if board[row][i] == char or board[i][col] == char:
			return false
	
	# Check 2x2 sub-box
	var start_row: int = (row / 2) * 2
	var start_col: int = (col / 2) * 2
	for i in range(start_row, start_row + 2):
		for j in range(start_col, start_col + 2):
			if board[i][j] == char:
				return false
	
	return true

func _check_if_softlocked() -> bool:
	var valid_count: int = 0;
	for x in range(4):
		for y in range(4):
			if grid[x][y] != ".":
				continue
			if _is_valid(grid, x, y, grid_stack[0]):
				valid_count += 1
	print(valid_count)
	if valid_count == 0:
		return true
	return false

func _regenerate() -> void:
	randomize()
	var solved: bool = false;
	while not solved:
		grid = _generate_diagonal_arr()
		solved = _solve(grid)
	remove_random_slots(percent_empty, grid)
