extends Control

func _process(delta):
	$Ammo.text = "_ " + String(get_tree().current_scene.get_node("YSort/Player/WeaponManager/Pistol9mm").ammo) + "/" + String(get_tree().current_scene.get_node("YSort/Player/WeaponManager/Pistol9mm").ammo)
