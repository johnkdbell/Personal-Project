extends KinematicBody2D

export var ACCELERATION = 900;
export var MAX_SPEED = 1000;
export var FRICTION = 1.05;
export var ITEM_NAME = "NULL";
export var ITEM_QUANTITY = 1;
export var ABSORBABLE = false;
export var FLOATING_TAB = false;

var velocity = Vector2.ZERO

var player = null
var being_picked_up = false

onready var playerDetection = $PlayerDetection;
onready var tabFloatingButton = $Tab;

func _physics_process(delta):
	# Display floating tab image above item drop
	if FLOATING_TAB == true:
		tabFloatingButton.visible = true;
	else:
		tabFloatingButton.visible = false;		
	
	# If the player is within the player detection zone and absorbable is true
	if playerDetection.can_see_player() && ABSORBABLE == true:
		var player = playerDetection.player;
		var direction = global_position.direction_to(player.global_position);
		var distance = global_position.distance_to(player.global_position);
		
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
		tabFloatingButton.visible = false;
		
		if distance < 10:
			PlayerInventory.add_item(ITEM_NAME, ITEM_QUANTITY)
			queue_free()
		
	# Else if the item is in the process of being able to be picked up and the pickup button is being held
	elif being_picked_up == true && Input.is_action_pressed("pickup"):
		var direction = global_position.direction_to(player.global_position);
		var distance = global_position.distance_to(player.global_position);
		
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
		tabFloatingButton.visible = false;
		ABSORBABLE = true;
		
		if distance < 10:
			PlayerInventory.add_item(ITEM_NAME, ITEM_QUANTITY)
			queue_free()
			
	velocity = move_and_slide(velocity / FRICTION)
	
func pick_up_item(body):
	player = body
	being_picked_up = true
