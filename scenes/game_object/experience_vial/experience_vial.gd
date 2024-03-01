extends Node2D

var tween_position_duration: float = 0.5
var tween_scale_duration: float = 0.15

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation_degrees = rad_to_deg(direction_from_start.angle()) + 90
	rotation = lerp_angle(rotation, target_rotation_degrees, 1 - exp(-2 * get_process_delta_time()))


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	# tell tween to do more then 1 animate.
	tween.set_parallel()
	# animate position.
	# *Note \ help you to new line the code
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, tween_position_duration)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
		
	# animate scale
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, tween_scale_duration)\
		.set_delay(max(tween_position_duration - tween_scale_duration, 0.1))
	# await for all animation done.
	tween.chain()
	# do callback went all animation done.
	tween.tween_callback(collect)
	
	$RandomStreamPlayer2DComponent.play_random()
