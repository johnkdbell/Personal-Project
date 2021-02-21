extends Node2D

#enum {
#	$Pistol9mm,
#	MP5
#}

onready var weapon = $Pistol9mm;

func input():
	if Input.is_action_pressed("right_mouse_button"):
		if Input.is_action_pressed("left_mouse_button"):
			weapon.shoot();
			print(weapon.magazine_size)
	elif Input.is_key_pressed(KEY_E):
		pass #reload
		

func reload():
	weapon.start_reload();
