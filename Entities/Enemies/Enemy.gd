extends KinematicBody2D

export var ACCELERATION = 100;
export var MAX_SPEED = 100;
export var FRICTION = 1000;
export var KNOCKBACK_AMOUNT = 20;

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn");

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO;
var state = CHASE;
var player_follow = 0
var starting_position;
var direction;
var player;

onready var sprite = $WalkAnimation;
onready var playerDetection = $PlayerDetection;
onready var closeToPlayer = $CloseToPlayer;
onready var wanderController = $WanderController;
onready var hurtbox = $Hurtbox;
onready var stats = $Stats;

func _ready():
	starting_position = get_global_position();
	state = pick_random_state([IDLE, WANDER]);

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta);
	knockback = move_and_slide(knockback);
	velocity = move_and_slide(velocity);
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
			sprite.stop();
			sprite.frame = 0;
			seek_player();
			if wanderController.get_time_left() == 0:
				update_wander();
			
		WANDER:
			seek_player();
			wander_towards_point(wanderController.target_position, delta)			
			if wanderController.get_time_left() == 0:
				update_wander();
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander();
			velocity = move_and_slide(velocity);
			
		CHASE:
			player = playerDetection.player;
			if player != null:
				chase_towards_point(player.global_position, delta, false)
			else:
				chase_towards_point(starting_position, delta, true)
			stand_next_to();
					
func wander_towards_point(area, delta):
	direction = global_position.direction_to(area);
	velocity = velocity.move_toward(direction * (MAX_SPEED / 4), FRICTION * delta);
	player_follow = int(4.0 * (direction.rotated(PI / 4.0).angle() + PI) / TAU)
	follow_direction();
	
func chase_towards_point(area, delta, returning_home):
	direction = global_position.direction_to(area);
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	animate_while_moving(delta, returning_home);
	
func animate_while_moving(delta, returning_home):	
	if velocity.length() > 0.1:
		player_follow = int(4.0 * (direction.rotated(PI / 4.0).angle() + PI) / TAU)
		follow_direction();
	
	if returning_home == true:
		if velocity.length() < 5:
			velocity = velocity.move_toward(direction / MAX_SPEED * ACCELERATION, FRICTION * delta);
			state = IDLE;

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE;
		
func update_wander():
	state = pick_random_state([IDLE, WANDER]);
	wanderController.start_wander_timer(rand_range(1, 3));
	
func pick_random_state(state_list):
	state_list.shuffle();
	return state_list.pop_front();
		
func stand_next_to():
	if closeToPlayer.can_see_player():
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION);
		sprite.stop();
		sprite.frame = 0;
		seek_player();

func follow_direction():
	match player_follow:
		0:
			sprite.play("walk_left")
		1:
			sprite.play("walk_up")
		2:
			sprite.play("walk_right")
		3:
			sprite.play("walk_down")

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage;
	knockback = area.knockback_vector * (KNOCKBACK_AMOUNT * 10);
	hurtbox.create_hit_effect();
	
func _on_Stats_no_health():
	queue_free();
	var enemyDeathEffect = EnemyDeathEffect.instance();
	get_parent().add_child(enemyDeathEffect);
	enemyDeathEffect.global_position = global_position;
