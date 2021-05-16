extends KinematicBody2D

export var damage = 1;
export var BULLET_SPEED = 18;

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn");

var angle = null;
var knockback = Vector2.ZERO;
var dir = 0;

onready var timer = $Timer;

func _ready():
	$Hitbox.damage = damage;
	
func _physics_process(delta):
	_launch_arrow();
	
func _launch_arrow():
	var move_dir = Vector2(1,0).rotated(dir);
	global_position += (move_dir * BULLET_SPEED)
	angle = Vector2(1,0).rotated(rotation);
	$Hitbox.knockback_vector = angle / 2000;

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		queue_free();
	if body.is_in_group("Collision"):
		queue_free()
		create_hit_effect();
		
func create_hit_effect():
	var effect = HIT_EFFECT.instance()
	var main = get_tree().current_scene;
	main.add_child(effect);
	effect.global_position = global_position - Vector2(-4, 8);

func update_target_position():
	queue_free();

func get_time_left():
	return timer.time_left;

func _on_Timer_timeout():
	update_target_position();

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
