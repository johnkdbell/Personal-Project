extends KinematicBody2D

export var ACCELERATION = 300;
export var MAX_SPEED = 50;
export var FRICTION = 200;
export var KNOCKBACK_AMOUNT = 20;

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn");

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO;
var knockback = Vector2.ZERO;
var state = CHASE;

onready var playerDetection = $PlayerDetection;
onready var wanderController = $WanderController;
onready var hurtbox = $Hurtbox;
onready var stats = $Stats;
#onready var softCollision = $SoftCollision;

func _ready():
	state = pick_random_state([IDLE, WANDER]);

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta);
	knockback = move_and_slide(knockback);
	
#	if softCollision.is_colliding():
#		velocity += softCollision.get_push_vector() * delta * 400;	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
			seek_player();
			if wanderController.get_time_left() == 0:
				update_wander();
				
		WANDER:
			seek_player();
			if wanderController.get_time_left() == 0:
				update_wander();
			move_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander();
			
		CHASE:
			var player = playerDetection.player;
			var look = self.get_node("RayCast2D")
			
			if player != null:
				move_towards_point(player.global_position, delta);
				for scent in player.scent_trail:
					look.cast_to = (scent.global_position - self.global_position)
					look.force_raycast_update()
					move_towards_point(scent.global_position, delta);
					break
			else:
				state = IDLE;
			
	velocity = move_and_slide(velocity);
	
func move_towards_point(area, delta):
	var direction = global_position.direction_to(area);
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	
func update_wander():
	state = pick_random_state([IDLE, WANDER]);
	wanderController.start_wander_timer(rand_range(1, 3));

func pick_random_state(state_list):
	state_list.shuffle();
	return state_list.pop_front();
		
func seek_player():
	if playerDetection.can_see_player():
		state = CHASE;

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage;
	knockback = area.knockback_vector * (KNOCKBACK_AMOUNT * 10);
	hurtbox.create_hit_effect();
	
func _on_Stats_no_health():
	queue_free();
	var enemyDeathEffect = EnemyDeathEffect.instance();
	get_parent().add_child(enemyDeathEffect);
	enemyDeathEffect.global_position = global_position;
