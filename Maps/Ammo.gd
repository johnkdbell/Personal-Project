extends KinematicBody2D

const ACCELERATION = 900;
const MAX_SPEED = 1000;
const FRICTION = 1.05;
export(bool) var ABSORBABLE;
export(bool) var FLOATING_TAB;

export(bool) var PISTOL9MM;
export(bool) var MP5

var velocity = Vector2.ZERO;
var being_picked_up = false;
var player;
var weapon;

onready var playerDetection = $PlayerDetection;
onready var tabFloatingButton = $Tab;
onready var pistol_9mm_ammo = get_node("/root/World/YSort/Player/WeaponManager/Pistol9mm")

func _physics_process(delta):
	if FLOATING_TAB == false: # Display floating tab image above item drop
		tabFloatingButton.visible = false;
	item_absorption(delta);
	velocity = move_and_slide(velocity / FRICTION);
	
func pick_up_item(body):
	player = body
	being_picked_up = true
	
func item_absorption(delta):
	active_weapon();
	if weapon.ammo != weapon.max_ammo:
#	if WeaponsManager.ammo != WeaponsManager.max_ammo:
		
		if (playerDetection.can_see_player() && ABSORBABLE == true):
			player = playerDetection.player;
			move_towards_direction(delta)
			
		elif (being_picked_up == true && Input.is_action_pressed("pickup")):
			move_towards_direction(delta)
			ABSORBABLE = true;
		else:
			pass;
		
func move_towards_direction(delta):
	var direction = global_position.direction_to(player.global_position);
	var distance = global_position.distance_to(player.global_position);
	
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	tabFloatingButton.visible = false;
	
	if distance < 10:
		ammo();
		queue_free();
		
func ammo():
	if PISTOL9MM == true && pistol_9mm_ammo.ammo >= (pistol_9mm_ammo.max_ammo - 17):
		weapon = pistol_9mm_ammo;
		pistol_9mm_ammo.ammo = pistol_9mm_ammo.max_ammo;
	else:
		pistol_9mm_ammo.ammo += 17;
		
func active_weapon():
	if PISTOL9MM == true:
		weapon = pistol_9mm_ammo;
