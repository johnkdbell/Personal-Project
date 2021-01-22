extends KinematicBody2D

export var ACCELERATION = 460
export var MAX_SPEED = 225
export var FRICTION = 200;

var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false

func _ready():
	item_name = "Slime Potion"
	
func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
	else:
		var direction = global_position.direction_to(player.global_position);
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity)

func pick_up_item(body):
	player = body
	being_picked_up = true
