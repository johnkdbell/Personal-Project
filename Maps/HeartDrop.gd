extends KinematicBody2D

export var ACCELERATION = 900;
export var MAX_SPEED = 1000;
export var FRICTION = 1.05;
export(bool) var ABSORBABLE;
export(bool) var FLOATING_TAB;

var velocity = Vector2.ZERO;
var being_picked_up = false;
var player;

onready var playerDetection = $PlayerDetection;
onready var tabFloatingButton = $Tab;

func _physics_process(delta):
	# Display floating tab image above item drop
	if FLOATING_TAB == false:
		tabFloatingButton.visible = false;
	item_absorption(delta);
	velocity = move_and_slide(velocity / FRICTION);
	
func pick_up_item(body):
	player = body
	being_picked_up = true
	
func item_absorption(delta):
	if (playerDetection.can_see_player() && ABSORBABLE == true):
		player = playerDetection.player;
		move_towards_direction(delta)
		
	elif (being_picked_up == true && Input.is_action_pressed("pickup")):
		move_towards_direction(delta)
		ABSORBABLE = true;
	
func move_towards_direction(delta):
	var direction = global_position.direction_to(player.global_position);
	var distance = global_position.distance_to(player.global_position);
	
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	tabFloatingButton.visible = false;
	
	if distance < 10:
		heart();
		queue_free();
		
		
func heart():
	PlayerStats.max_health += 1;
	PlayerStats.health = PlayerStats.max_health;