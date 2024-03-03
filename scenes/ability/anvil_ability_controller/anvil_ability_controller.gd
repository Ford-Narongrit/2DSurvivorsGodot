extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

@export var anvil_ability_scene: PackedScene

var additional_anvil_amount = 0

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var anvil_count = additional_anvil_amount + 1
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degress = 360.0 / anvil_count
	for i in anvil_count:
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degress))
		var spawn_position = player.global_position + (adjusted_direction * randf_range(0, BASE_RANGE))
		
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		if not result.is_empty():
			spawn_position = result["position"]
		
		var anvil_ability = anvil_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.hitbox_component.damage = BASE_DAMAGE


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_amount":
		additional_anvil_amount = current_upgrades["anvil_amount"]["quantity"]
