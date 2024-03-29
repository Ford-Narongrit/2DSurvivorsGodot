extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased
signal health_increased

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount: float):
	current_health = min(current_health + heal_amount, max_health)
	health_changed.emit()
	health_increased.emit()


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
