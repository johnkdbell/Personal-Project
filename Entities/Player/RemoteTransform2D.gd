extends RemoteTransform2D

const MAX_SPEED = 150
const ACCELERATION = 0.025
var MOVE;

func _physics_process(_delta):
	if get_parent().is_move == true:
		print(get_parent().is_move)
		if Input.get_action_strength("ui_right"):
			position.x = lerp(position.x - 1, MAX_SPEED, ACCELERATION)
		if Input.get_action_strength("ui_left"):
			position.x = lerp(position.x - 6, MAX_SPEED, ACCELERATION)
		if Input.get_action_strength("ui_up"):
			position.y = lerp(position.y - 6, MAX_SPEED, ACCELERATION)
			position.x = lerp(position.x, MAX_SPEED * ACCELERATION, ACCELERATION)
		if Input.get_action_strength("ui_down"):
			position.y = lerp(position.y - 2, MAX_SPEED, ACCELERATION)
			position.x = lerp(position.x, MAX_SPEED * ACCELERATION, ACCELERATION)		
