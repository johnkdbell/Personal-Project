extends Camera2D

func _input(event):	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if self.zoom > Vector2(0.75, 0.75):
					self.zoom = self.zoom - Vector2(0.05, 0.05);
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if self.zoom < Vector2(1.5, 1.5):
					self.zoom = self.zoom + Vector2(0.05, 0.05);

#const LOOK_AHEAD_FACTOR = 0.2;
#const SHIFT_TRANS = Tween.TRANS_SINE;
#const SHIFT_EASE = Tween.EASE_OUT;
#const SHIFT_DURATION = 1.0;
#
#var facing = 0;
#
#onready var prev_camera_pos = get_camera_position();
#onready var tween = $ShiftTween;
#
#func _process(delta):
#	_check_facing();
#	prev_camera_pos = get_camera_position();
#
#func _check_facing():
#	var new_facing_x = sign(get_camera_position().x - prev_camera_pos.x);
#	var new_facing_y = sign(get_camera_position().y - prev_camera_pos.y);
#
#	if new_facing_x != 0 && facing != new_facing_x:
#		facing = new_facing_x;
#		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing;
##		position.x = target_offset;
#
#		tween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE);
#		tween.start();
#
#	elif new_facing_y != 0 && facing != new_facing_y:
#		facing = new_facing_y;
#		var target_offset = get_viewport_rect().size.y * facing;
##		position.y = target_offset;
#

#func _physics_process(delta):
#		if get_node("../YSort/Player").global_position.x > 15 or get_node("../YSort/Player").global_position.y > 15 or -get_node("../YSort/Player").global_position.x > -15 or -get_node("../YSort/Player").global_position.y > -15:
#				global_position = get_node("../YSort/Player").global_position.round()
#				force_update_scroll()
#




## Smoothing duration in seconds
#const SMOOTHING_DURATION: = 0.2
#
## The node to follow
#onready var target: Node2D = get_node("../YSort/Player");
#
## Current position of the camera
#var current_position: Vector2
#
## Position the camera is moving towards
#var destination_position: Vector2
#
#func _ready() -> void:
#	current_position = position
#
#func _physics_process(delta):
#	if get_node("../YSort/Player").global_position.x > 15 or get_node("../YSort/Player").global_position.y > 15 or -get_node("../YSort/Player").global_position.x > -15 or -get_node("../YSort/Player").global_position.y > -15:
#		global_position = get_node("../YSort/Player").global_position.round()
#		force_update_scroll()
#		destination_position = target.global_position
#		current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
#
#	position = current_position.round()
#	force_update_scroll()
