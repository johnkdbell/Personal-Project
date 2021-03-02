extends RayCast2D

var is_casting := false setget set_is_casting;


func _ready():
	set_physics_process(false);
	$Line2D.points[1] = Vector2.ZERO

func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	$Line2D.points[1] = cast_point

func set_is_casting(cast):
	is_casting = cast;
	if is_casting:
		appear();
	else:
		disappear();
	set_physics_process(is_casting);

func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 2.0, 0.1)
	$Tween.start();

func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 2.0, 0, 0.1)
	$Tween.start();












