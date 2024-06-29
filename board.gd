extends Node2D

var rows: int = 3
var cols: int = 3#rows
var boardsize = 600

var board_elems

var piece_scene: PackedScene = preload("element.tscn")

# Array cheat sheet:
# a = [[1,2],[3,4]]
# a[0][0] = 1
# a[0][1] = 2
# a[1][0] = 3
# a[1][1] = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	board_elems = init_board_grid(cols,rows)
	Global.win.connect(_on_win)

func get_piece_loc(i,j):
	var x_width = boardsize / cols
	var y_width = boardsize / rows
	return Vector2(x_width * (j + 0.5), y_width * (i + 0.5))

func init_board_grid(board_height: int, board_width: int = board_height):
	var board_elems = []
	for i in board_height:
		board_elems.append([])
		for j in board_width:
			board_elems[i].append(piece_scene.instantiate())
			board_elems[i][j].position = get_piece_loc(i,j)
			add_child(board_elems[i][j])
	
	for i in board_height:
		for j in board_width:
			if i > 0:  # Set above
				board_elems[i][j].directions[0][0] = board_elems[i-1][j]
				if j > 0:  # Set above left
					board_elems[i][j].directions[2][0] = board_elems[i-1][j-1]
				if j < board_width - 1:  # Set above right
					board_elems[i][j].directions[3][0] = board_elems[i-1][j+1]
			if i < board_height - 1:  # Set below
				board_elems[i][j].directions[0][1] = board_elems[i+1][j]
				if j > 0:  # Set below left
					board_elems[i][j].directions[3][1] = board_elems[i+1][j-1]
				if j < board_width - 1:  # Set below right
					board_elems[i][j].directions[2][1] = board_elems[i+1][j+1]
			if j > 0:  # Set left
				board_elems[i][j].directions[1][0] = board_elems[i][j-1]
			if j < board_width - 1:  # Set right
				board_elems[i][j].directions[1][1] = board_elems[i][j+1]
	return board_elems

func _on_win():
	print("There's a winner: " + str(Global.winner))

