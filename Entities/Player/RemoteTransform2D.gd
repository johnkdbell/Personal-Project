extends RemoteTransform2D

const MAX_SPEED = 150
const ACCELERATION = 0.025
var MOVE;
var aiming;
onready var timer := get_parent().get_node("Timer");

func _physics_process(delta):
	if Input.is_action_pressed("right_mouse_button"):
		aim_camera(delta);
		get_parent().get_node("Camera2D").smoothing_speed = 4;
	else:
		smooth_camera();

func aim_camera(delta):
	if Input.is_action_pressed("right_mouse_button"):
		aiming = true;
		timer.stop();
		position.x = clamp(get_local_mouse_position().x, -50, 50);
		position.y = clamp(get_local_mouse_position().y, -50, 50);
		drag(false);
	
func smooth_camera():
	if get_parent().is_move == true:
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
		if Input.is_action_just_released("right_mouse_button"):
			aiming = true;
			drag(false);
			start(0.5)
	elif Input.is_action_just_released("right_mouse_button"):
		aiming = false;
		drag(true);
		start(0.5)

func drag(setting):
	get_parent().get_node("Camera2D").drag_margin_v_enabled = setting;
	get_parent().get_node("Camera2D").drag_margin_h_enabled = setting;
	
func start(duration = 0.5):
	timer.wait_time = duration;
	timer.start();

func _on_Timer_timeout():
	timer.stop();
#	position.x = clamp(position.x, 50, -50);
#	position.y = clamp(position.y, 50, -50);
	get_parent().get_node("Camera2D").smoothing_speed = 1;
	
	
