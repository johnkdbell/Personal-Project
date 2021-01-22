extends KinematicBody2D

export var ACCELERATION = 900;
export var MAX_SPEED = 1000;
export var FRICTION = 1.05;
export var ITEM_NAME = "NULL";
export var ITEM_QUANTITY = 1;


var velocity = Vector2.ZERO

var player = null
var being_picked_up = false
	
func _physics_process(delta):
	if being_picked_up == false && Input.is_action_just_released("pickup"):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		
	elif being_picked_up == true && Input.is_action_pressed("pickup"):
		var direction = global_position.direction_to(player.global_position);
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
		if being_picked_up == false && Input.is_action_just_released("pickup"):
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			PlayerInventory.add_item(ITEM_NAME, ITEM_QUANTITY)
			queue_free()
			
	velocity = move_and_slide(velocity / FRICTION)
	
func pick_up_item(body):
	player = body
	being_picked_up = true
