extends Area2D

var cover_object = null;

func can_see_cover_object():
	return cover_object != null;
	
func _on_CloseToCoverObject_body_entered(body):
	cover_object = body;

func _on_CloseToCoverObject_body_exited(body):
	cover_object = !body;
	cover_object = null;

