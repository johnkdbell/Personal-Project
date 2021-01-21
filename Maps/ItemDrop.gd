extends KinematicBody2D

#const player_stats = preload("res://Entities/Player/Player.gd")

export var ACCELERATION = 100;
export var MAX_SPEED 	= 200;
export var FRICTION 	= 10000;

enum {
	IDLE,
	CHASE
}

var item_name;
var velocity 	= Vector2.ZERO;
var state 		= CHASE;

onready var playerDetection = $PlayerDetection;

func _ready():
	item_name = "Slime Potion";
	
func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
			seek_player();

		CHASE:
			var player = playerDetection.player;
			if player != null:
				move_towards_point(player.global_position, delta)
			else:
				state = IDLE;
			
	velocity = move_and_slide(velocity);

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE;
	
func move_towards_point(area, delta):
	var direction = global_position.direction_to(area);
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
