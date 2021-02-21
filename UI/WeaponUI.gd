extends Control

onready var pistol9mm = get_node("/root/World/YSort/Player/WeaponManager/Pistol9mm")

func _process(delta):
	$Ammo.text = "_ " + String(pistol9mm.magazine_size) + "/" + String(pistol9mm.ammo)

#onready var pistol9mm = "0"
#
#func _process(delta):
#	$Ammo.text = "_ " + pistol9mm + "/" + pistol9mm
