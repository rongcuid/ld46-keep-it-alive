extends Area

"""
A Trebuchet which can attack and be destroyed
"""

signal destroyed(score)

var _transient: Spatial

onready var body: Spatial = $"Trebuchet Body"
onready var sling: Spatial = $"Trebuchet Sling"

const Rock = preload("res://src/Rock.tscn")

var rock = null


func set_transient(t) -> void:
	_transient = t


func _on_started_attack() -> void:
	"""
	Spawns a rock at beginning of animation
	"""
	rock = Rock.instance()
	sling.get_node("Cradle").add_child(rock)


func _on_released_attack() -> void:
	"""
	Releases the rock
	"""
	#if not is_instance_valid(rock):
	#	return
	#rock = Rock.instance()
	rock.get_parent().remove_child(rock)
	_transient.add_child(rock)
	rock.global_translate(sling.get_node("Cradle").to_global(Vector3(0,0,0)))
	rock.apply_central_impulse(Vector3(-1, 1, 0) * 15)
	rock.launched = true
	rock = null


func _on_Trebuchet_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		# If player touches
		emit_signal("destroyed", 10)
		queue_free()


func _on_game_started():
	$AnimationPlayer.play("attack")
