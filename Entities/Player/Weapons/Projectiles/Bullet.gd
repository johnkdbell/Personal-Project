extends RigidBody2D

const CAST_VELOCITY = Vector2(800,0);
var angle = null;
var knockback_vector = Vector2.ZERO;

onready var timer = $Timer;

func _ready():
	_launch_arrow();
	
func _launch_arrow():
	apply_impulse(Vector2(), Vector2(CAST_VELOCITY).rotated(rotation));
	angle = Vector2(CAST_VELOCITY).rotated(rotation);

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
	#		var my_texture = load("res://Projectiles/Bullet.png");
	#		var sprite = Sprite.new();
	#		sprite.look_at(angle);
	#		sprite.set_offset(Vector2(-9,0));
	#		sprite.set_texture(my_texture);
	#		body.add_child(sprite);
		queue_free();
		
func update_target_position():
	queue_free();

func get_time_left():
	return timer.time_left;

func _on_Timer_timeout():
	update_target_position();

