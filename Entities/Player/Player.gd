extends KinematicBody2D

export var MAX_SPEED = 150;
export var ACCELERATION = 3;
export var FRICTION = 0.3;
export var projectileDelay: float = 0.1;

enum {
	MOVE,
	ROLL,
	ATTACK,
	SHOOT
}

var state = MOVE;
var velocity = Vector2.ZERO
var player_bullet := preload("res://Entities/Player/Weapons/Projectiles/Bullet.tscn");
var roll_vector = Vector2.DOWN;

onready var	animationPlayer = $AnimationPlayer;
onready var animationTree = $AnimationTree;
onready var animationState = animationTree.get("parameters/playback");
onready var projectileDelayTimer := $ProjectileDelayTimer;
onready var meleeHitbox = $HitboxPivot/MeleeHitbox;

func _ready():
	animationTree.active = true;
	meleeHitbox.knockback_vector = roll_vector;
	randomize();

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta);
			apply_movement(delta)
		ROLL:
			pass;
		ATTACK:
			attack_state(delta);
		SHOOT:
			move_state(delta);
			apply_movement(delta);
	
func move_state(delta):
	var input_vector = Vector2.ZERO;	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	if Input.is_action_pressed("right_mouse_button"):
		if Input.is_action_just_pressed("shoot"):
			state = SHOOT;
			spawn_arrow();
	elif Input.is_action_just_pressed("left_mouse_button"):
		velocity = Vector2.ZERO;
		state = ATTACK;
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector;
		meleeHitbox.knockback_vector = input_vector;
		animationTree.set("parameters/Idle/blend_position", input_vector);
		animationTree.set("parameters/Walk/blend_position", input_vector);
		animationTree.set("parameters/Attack/blend_position", input_vector);
		animationState.travel("Walk");
		velocity = lerp(velocity, input_vector.normalized() * MAX_SPEED, ACCELERATION * delta);
	else:
		animationState.travel("Idle");
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
func apply_movement(delta):
	velocity = move_and_slide(velocity)
	
func attack_state(delta):
	animationState.travel("Attack");
	
func shoot_state(delta):
	state = SHOOT;
	shoot_animation_finished();
	
func attack_animation_finished():
	state = MOVE;
	
func shoot_animation_finished():
	state = MOVE;
	
func spawn_arrow():
	if projectileDelayTimer.is_stopped():
		projectileDelayTimer.start(projectileDelay);
		var bullet := player_bullet.instance();
		bullet.rotation = get_angle_to(get_global_mouse_position());
		bullet.position = position;
		get_tree().current_scene.add_child(bullet);