extends Node2D

var state: int = 0
var directions = []
var dir_len: int
# By default, four directions:
#	above/below
#	left/right
#	aboveleft/belowright
#	aboveright/belowleft
var dir_name: Dictionary = {
	0: {0:"above",1:"below"},
	1: {0:"left",1:"right"},
	2: {0:"aboveleft",1:"belowright"},
	3: {0:"aboveright",1:"belowleft"},
}

func _init(dir_num: int = 4):
	dir_len = dir_num
	for i in dir_num:
		directions.append([])
		for j in 2:
			directions[i].append(null)

func _on_piece_changed():
	state = 3 - Global.turn
	if check_for_win():
		Global.winner = state
		Global.win.emit()

func check_for_win():
	for dir in dir_len:
		var max_length = check_for_win_dir(state,dir,Global.win_len)
		if max_length >= Global.win_len:
			return true
	return false

func check_for_win_dir(curr_state,dir,check_length):
	var v1 = check_for_win_recursive(curr_state,dir,0,directions[dir][0],check_length)
	var v2 = check_for_win_recursive(curr_state,dir,1,directions[dir][1],check_length)
	return 1 + v1 + v2
	
func check_for_win_recursive(curr_state,dir,dir_binary,curr_piece,check_length):
	if check_length == 1:
		return 0
	elif curr_piece == null:
		return 0
	else:
		if curr_piece.state == curr_state:
			return 1 + check_for_win_recursive(curr_state,dir,dir_binary,curr_piece.directions[dir][dir_binary],check_length-1)
		else:
			return 0
