extends Camera2D

#Zoom camera
func _input(event):	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if self.zoom > Vector2(0.75, 0.75):
					self.zoom = self.zoom - Vector2(0.05, 0.05);
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if self.zoom < Vector2(1.5, 1.5):
					self.zoom = self.zoom + Vector2(0.05, 0.05);
