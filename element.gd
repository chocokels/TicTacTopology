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
