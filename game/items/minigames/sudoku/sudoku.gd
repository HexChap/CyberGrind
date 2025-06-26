extends Node3D

@onready var game_timer = $Timer
@export var percent_empty = 0.6;
@export var time = 0;
@export var score = 0;
@export var rollbacks = 0;
@export var game_over: bool = false;
@export var grid: Array;
@export var grid_stack: Array;
@export var traceback: Array[Array];

func _ready():
	add_to_group("SudokuRoot")
	var nz = [1, 2, 3]
	print(nz.front())
	print(nz.back())
	game_timer.wait_time = 1.0
	start_game(240, 3, 0.8)
	


func _process(delta):
	pass

func start_game(_time: int, _rollbacks: int, _percent_empty: float) -> void:
	_regenerate(_percent_empty)
	time = _time
	rollbacks = _rollbacks
	game_over = false;
	game_timer.start()
	for row in grid:
		print(row)
	return

func _on_GameTimer_timeout():
	time -= 1
	print("second")
	if time <= 0:
		game_timer.stop()
		end_game()

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
	if _is_game_won():
		end_game()
		GameState.decrease_brain_strain()
		game_over = false;
	
	if _check_if_softlocked() && rollbacks == 0:
		end_game()
		start_game(time, rollbacks, percent_empty)
	
	score += _calculate_base_score(x, y) 
	traceback.push_front([x, y, grid[x][y]])
	
	print(grid_stack)
	return true

func backtrack() -> bool:
	if rollbacks == 0 or traceback.is_empty():
		return false

	var last_op = traceback.front()
	var x = last_op[0]
	var y = last_op[1]
	var placed_val = last_op[2]

	grid[x][y] = "."
	grid_stack.push_front(placed_val)

	traceback.pop_front()

	rollbacks -= 1

	return true

func _calculate_base_score(x: int, y: int) -> int:
	var raw_score: int = 0;
	for _x in range(4):
		raw_score += int(grid[_x][y])
	for _y in range(4):
		raw_score += int(grid[x][_y])
	
	return raw_score;

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

func end_game() -> void:
	time = 0;
	score = 0;
	rollbacks = 0;
	for x in range(4):
		for y in range(4):
			grid[x][y] = ".";
	grid_stack.clear();
	traceback.clear();
	return

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

func _regenerate(_percent_empty: float) -> void:
	randomize()
	var solved: bool = false;
	while not solved:
		grid = _generate_diagonal_arr()
		solved = _solve(grid)
	percent_empty = _percent_empty
	remove_random_slots(percent_empty, grid)

func _is_game_won() -> bool:
	for x in range(4):
		for y in range(4):
			if grid[x][y] == ".":
				return false
	
	return true
