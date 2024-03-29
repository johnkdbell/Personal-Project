extends Area2D

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn");

var invincible = false setget set_invincible;

onready var timer = $Timer;

signal invincibility_start
signal invincibility_end

func set_invincible(value):
	invincible = value;
	if invincible == true:
		emit_signal("invincibility_start");
	else:
		emit_signal("invincibility_end");
		
func start_invincibility(duration):
	self.invincible = true;
	timer.start(duration);

func create_hit_effect():
	var effect = HIT_EFFECT.instance()
	var main = get_tree().current_scene;
	main.add_child(effect);
	effect.global_position = global_position - Vector2(0, 8);

func _on_Timer_timeout():
	self.invincible = false;

func _on_Hurtbox_invincibility_start():
	set_deferred("monitorable", false);

func _on_Hurtbox_invincibility_end():
	monitorable = true;
