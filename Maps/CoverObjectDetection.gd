extends Area2D

var damage = 0;

var cover_object = null;

func can_see_cover_object():
	return cover_object != null;
	
func _on_CoverObjectDetection_body_entered(body):
	cover_object = body;

func _on_CoverObjectDetection_body_exited(_body):
	cover_object = null;
