extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var currect_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	for i in 2:
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = currect_upgrades.has(upgrade.id)
	if !has_upgrade:
		currect_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		currect_upgrades[upgrade.id]["quantity"] += 1
	
	GameEvents.emit_ability_upgrade_added(upgrade, currect_upgrades)


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
