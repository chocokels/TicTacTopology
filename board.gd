extends Node2D

var rows: int = 5
var cols: int = 5#rows
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
	board_elems = init_board_grid()
	#torus()
	Global.win.connect(_on_win)

func get_piece_loc(i,j):
	var x_width = boardsize / cols
	var y_width = boardsize / rows
	return Vector2(x_width * (j + 0.5), y_width * (i + 0.5))

# Connects the directions of the two elements
#   connect_dirs(0, elem_1,elem_2): elem_1 is above elem_2
#   connect_dirs(1, elem_1,elem_2): elem_1 is left of elem_2
#   connect_dirs(2, elem_1,elem_2): elem_1 is aboveleft of elem_2
#   connect_dirs(3, elem_1,elem_2): elem_1 is aboveright of elem_2
func connect_dirs(axis,elem_1,elem_2):
	elem_2.directions[axis][0] = elem_1
	elem_1.directions[axis][1] = elem_2

func init_board_grid():
	var board_elems = []
	for i in rows:
		board_elems.append([])
		for j in cols:
			board_elems[i].append(piece_scene.instantiate())
			board_elems[i][j].position = get_piece_loc(i,j)
			add_child(board_elems[i][j])
	
	for i in rows:
		for j in cols:
			if i > 0:  
				# Set above/below
				connect_dirs(0,board_elems[i-1][j],board_elems[i][j])
				if j > 0:
					# Set aboveleft/belowright
					connect_dirs(2,board_elems[i-1][j-1],board_elems[i][j])
					# Set aboveright/belowleft
					connect_dirs(3,board_elems[i-1][j],board_elems[i][j-1])
			if j > 0:
				# Set left/right
				connect_dirs(1,board_elems[i][j-1],board_elems[i][j])
	return board_elems

func _on_win():
	print("There's a winner: " + str(Global.winner))

# Identificate!!!
# Identify top and bottom edges
func identify_top():
	for i in cols:
		connect_dirs(0,board_elems[rows-1][i],board_elems[0][i])
		if i > 0:
			connect_dirs(2,board_elems[rows-1][i-1],board_elems[0][i])
			connect_dirs(3,board_elems[rows-1][i],board_elems[0][i-1])
			
# Identificate!!!
# Idetify left and right edges
func identify_left():
	for i in rows:
		connect_dirs(1,board_elems[i][cols-1],board_elems[i][0])
		if i > 0:
			connect_dirs(2,board_elems[i-1][cols-1],board_elems[i][0])
			connect_dirs(3,board_elems[i-1][0],board_elems[i][cols-1])
			

func torus():
	identify_top()
	identify_left()
	connect_dirs(2,board_elems[rows-1][cols-1],board_elems[0][0])
	connect_dirs(3,board_elems[rows-1][0],board_elems[0][cols-1])
