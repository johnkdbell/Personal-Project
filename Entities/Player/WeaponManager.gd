extends Node2D

onready var weapon = $Pistol9mm;

func _init():
	input();

func input():
	if Input.is_action_pressed("right_mouse_button"):
		if Input.is_action_pressed("shoot"):
			weapon.shoot();

