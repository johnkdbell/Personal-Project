extends CPUParticles2D

func _on_Timer_timeout():
	# This will make sure all processes are turned off to ensure effect is only rendering
	set_process(false);
	set_physics_process(false);
	set_process_input(false);
	set_process_internal(false);
	set_process_unhandled_input(false);
	set_process_unhandled_key_input(false);
