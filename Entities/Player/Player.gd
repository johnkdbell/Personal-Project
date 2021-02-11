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

const scent_scene = preload("res://Entities/Player/Scent.tscn");

var state = MOVE;
var velocity = Vector2.ZERO
var player_bullet := preload("res://Entities/Player/Weapons/Projectiles/Bullet.tscn");
var roll_vector = Vector2.DOWN;
var is_move = true;
var scent_trail = [];
var stats = PlayerStats;

onready var	animationPlayer = $AnimationPlayer;
onready var animationTree = $AnimationTree;
onready var animationState = animationTree.get("parameters/playback");
onready var projectileDelayTimer := $ProjectileDelayTimer;
onready var meleeHitbox = $HitboxPivot/MeleeHitbox;
onready var pickupZone = $PickupZone;
onready var pickupZoneCollision = $PickupZone/CollisionShape2D;
onready var hurtbox = $Hurtbox;

func _ready():
	meleeHitbox.knockback_vector = roll_vector;
	$ScentTimer.connect("timeout", self, "add_scent");
	stats.connect("no_health", self, "queue_free");
	print(stats.health)
	randomize();

func _physics_process(delta):
	absorption_press();
	match state:
		MOVE:
			move_state(delta);
			apply_movement()
		ROLL:
			pass;
		ATTACK:
			attack_state();
		SHOOT:
			move_state(delta);
			apply_movement();
	
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
		is_move = true;
		roll_vector = input_vector;
		meleeHitbox.knockback_vector = input_vector;
		animationTree.set("parameters/Idle/blend_position", input_vector);
		animationTree.set("parameters/Walk/blend_position", input_vector);
		animationTree.set("parameters/Attack/blend_position", input_vector);
		animationState.travel("Walk");
		velocity = lerp(velocity, input_vector.normalized() * MAX_SPEED, ACCELERATION * delta);
	else:
		is_move = false;
		animationState.travel("Idle");
		velocity = lerp(velocity, Vector2.ZERO, FRICTION);
	
func apply_movement():
	velocity = move_and_slide(velocity);
	
func attack_state():
	animationState.travel("Attack");
	
func shoot_state():
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
		
func absorption_press():
	var absorption_press = 0;
	if Input.is_action_just_pressed("pickup"):
		absorption_press += 1;
	if Input.is_action_just_released("pickup"):
		absorption_press -= 1;
		
	if absorption_press == 1 || absorption_press == -1:
		if pickupZone.items_in_range.size() > 0:
			var pickup_item = pickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			pickupZone.items_in_range.erase(pickup_item)
			
func add_scent():
	var scent = scent_scene.instance();
	scent.player = self;
	scent.position = self.position;
	if is_move == true:
		get_tree().current_scene.add_child(scent)
		scent_trail.push_front(scent)

func _on_Hurtbox_area_entered(area):
	if hurtbox.invincible == true:
		stats.health -= 0;
	else:
		hurtbox.start_invincibility(3);
		hurtbox.create_hit_effect();
		stats.health -= area.damage;
