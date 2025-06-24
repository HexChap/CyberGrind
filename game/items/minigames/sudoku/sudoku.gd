extends Node3D

# test tommorow
# it should use the arr as a reference and if it works its true
func _ready():
	print(_solve(_generate_diagonal_arr()))

func _process(delta):
	pass



func _generate_diagonal_arr() -> Array:
	var diagonal_arr: Array = []
	for i in range(4):
		var row: Array = []
		for j in range(4):
			row.append(".")
		diagonal_arr.append(row)

	for n in range(4):
		diagonal_arr[n][n] = str(randi_range(1, 4))

	return diagonal_arr


func _solve(board: Array) -> bool:
	for row in range(4):
		for col in range(4):
			if board[row][col] == ".":
				for num in range(1, 5):  # 1 to 9 inclusive
					var char = str(num)
					if _is_valid(board, row, col, char):
						board[row][col] = char
						if _solve(board):
							return true
						board[row][col] = "."
				return false
	return true

func _is_valid(board: Array, row: int, col: int, char: String) -> bool:
	# Check row and column
	for i in range(4):
		if board[row][i] == char or board[i][col] == char:
			return false
	
	# Check 3x3 sub-box
	var start_row = (row / 2) * 2
	var start_col = (col / 2) * 2
	for i in range(start_row, start_row + 2):
		for j in range(start_col, start_col + 2):
			if board[i][j] == char:
				return false
	
	return true
