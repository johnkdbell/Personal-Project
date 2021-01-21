extends Area2D

var player = null;

func can_see_player():
	return player != null;
	
func _on_CloseToPlayer_body_entered(body):
	player = body;

func _on_CloseToPlayer_body_exited(body):
	player = !body;
	player = null;
