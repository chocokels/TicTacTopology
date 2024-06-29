extends Sprite2D

signal changed

var state: int = 0

var images: Dictionary = {
	0: preload("art/blank.png"),
	1: preload("art/o.png"),
	2: preload("art/x.png"),
}

func _ready():
	texture = images[0]
	self_modulate.a = 0.2
	#print(str(get_tree().current_scene))

func new_move(new_state: int):
	state = new_state
	texture = images[new_state]
	self_modulate.a = 1
	Global.turn = 3 - Global.turn
	changed.emit()

func _on_button_mouse_entered():
	if state == 0:
		texture = images[Global.turn]

func _on_button_mouse_exited():
	if state == 0:
		texture = images[0]

func _on_button_pressed():
	new_move(Global.turn)
