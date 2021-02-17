extends Node

enum {
	OFF,
	ON
}

var fullscreen = OFF;

func _ready():
	set_process(true);

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		print("Exiting...")
		get_tree().quit()
	
	elif Input.is_action_just_pressed("restart"):
		print("Restarting...");
		PlayerStats.restart_health();
		get_tree().reload_current_scene();

	if Input.is_action_just_pressed("full_screen") && !OS.window_fullscreen == true:
		OS.window_fullscreen = true;
	elif Input.is_action_just_pressed("full_screen") && !OS.window_fullscreen == false:
		OS.window_fullscreen = false;

