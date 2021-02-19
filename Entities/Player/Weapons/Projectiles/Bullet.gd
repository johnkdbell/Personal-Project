extends RigidBody2D

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn");

const CAST_VELOCITY = Vector2(2000,0);
var angle = null;
var knockback = Vector2.ZERO;

onready var timer = $Timer;

func _ready():
	_launch_arrow();
	
func _launch_arrow():
	apply_impulse(Vector2(), Vector2(CAST_VELOCITY).rotated(rotation));
	angle = Vector2(CAST_VELOCITY).rotated(rotation);
	$Hitbox.knockback_vector = angle / 2000;

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		queue_free();
#		var my_texture = load("res://Entities/Player/Weapons/Projectiles/Bullet.png");
#		var sprite = Sprite.new();
#		sprite.look_at(angle);
#		sprite.set_offset(Vector2(-9,0));
#		sprite.set_texture(my_texture);
#		body.add_child(sprite);
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

