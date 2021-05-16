extends KinematicBody2D

export var MAX_SPEED = 150;
export var ACCELERATION = 3;
export var FRICTION = 0.4;
export var INVINCIBILITY_TIME = 1;

enum {
	MOVE,
	ROLL,
	ATTACK,
	SHOOT
}

const scent_scene = preload("res://Entities/Player/Scent.tscn");

var state = MOVE;
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN;
var is_move = true;
var scent_trail = [];
var stats = PlayerStats;
var flashlight_off = true;

var player_vol = Vector2(1,1) #For AI Shooting?

onready var weapon = PlayerWeapons.get_node("Pistol9mm");
onready var	animationPlayer = $AnimationPlayer;
onready var animationTree = $AnimationTree;
onready var animationState = animationTree.get("parameters/playback");
onready var meleeHitbox = $HitboxPivot/MeleeHitbox;
onready var pickupZone = $PickupZone;
onready var pickupZoneCollision = $PickupZone/CollisionShape2D;
onready var hurtbox = $Hurtbox;
onready var screenShake = $Camera2D/ScreenShake;
onready var weapon_manager = $WeaponManager;

func _ready():
	meleeHitbox.knockback_vector = roll_vector;
	$ScentTimer.connect("timeout", self, "add_scent");
	stats.connect("no_health", self, "queue_free");
	randomize();
	

func _physics_process(delta):
	absorption_press();
	flashlight();
	
	weapon_manager.input();
	match state:
		MOVE:
			move_state(delta);
			apply_movement(delta)
		ROLL:
			pass;
		ATTACK:
			attack_state();
		SHOOT:
			move_state(delta);
			apply_movement(delta);

func move_state(delta):
	var input_vector = Vector2.ZERO;	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	if Input.is_action_pressed("right_mouse_button"):
		$AimingLaser.is_casting = true;
		$AimingLaser.cast_to = get_transform().affine_inverse() * get_global_mouse_position() / 1.1;
		if Input.is_action_just_pressed("left_mouse_button") || Input.is_action_pressed("left_mouse_button"):
			state = SHOOT;
#			weapon.shoot();
	elif Input.is_action_just_released("right_mouse_button"):
		$AimingLaser.is_casting = false;
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
		input_vector = input_vector.normalized()
		velocity = lerp(velocity, input_vector * MAX_SPEED, ACCELERATION);
	else:
		is_move = false;
		animationState.travel("Idle");
		velocity = lerp(velocity, Vector2.ZERO, FRICTION);
	
func apply_movement(delta):
	velocity = move_and_slide(velocity * delta);
	
func attack_state():
	animationState.travel("Attack");
	
func shoot_state():
	state = SHOOT;
	shoot_animation_finished();
	
func attack_animation_finished():
	state = MOVE;
	
func shoot_animation_finished():
	state = MOVE;
		
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
		stats.battery -= 0;
		stats.health -= 0;
	else:
		screenShake.start(0.2, 10, 10);
		hurtbox.start_invincibility(INVINCIBILITY_TIME);
		hurtbox.create_hit_effect();
		animationPlayer.play("FlashDamage")
		if stats.battery == 0:
			stats.health -= area.damage;
		else:
			stats.battery -= area.damage;

func flashlight():
	$AimingLaser/Light/Light2D.position = (get_transform().affine_inverse() * get_global_mouse_position()) / 1.5;
	
	if flashlight_off == false:
		if stats.flashlight > 0:
			stats.flashlight -= 0.01;
			light(true, 1)
		elif stats.flashlight <= 0:
			stats.flashlight -= 0;
			light(false, 0.5)
	elif flashlight_off == true:
		if stats.flashlight < 100:
			stats.flashlight += 0.02;
			light(false, 0.5)

	if Input.is_action_just_pressed("flashlight") && flashlight_off == false:
		flashlight_off = true;
	elif Input.is_action_just_pressed("flashlight") && flashlight_off == true:
		if DayNightCycle.hour >= 6 && DayNightCycle.hour < 21:
			if stats.flashlight > 0:
				flashlight_off = false;
			elif stats.flashlight <= 0:
				flashlight_off = true;
		else:
			if stats.flashlight > 0:
				flashlight_off = false;
			elif stats.flashlight <= 0:
				flashlight_off = true;

func light(active, lighting):
	if active == true:
		flashlight_off = false;
		$AimingLaser/Light/Light2D.color = Color(0.71,0.66,0.56,lighting);
		$AimingLaser/Light/Light2D.show();
	elif active == false:
		flashlight_off = true;
		$AimingLaser/Light/Light2D.color = Color(0.71,0.66,0.56,lighting);
		$AimingLaser/Light/Light2D.hide();
