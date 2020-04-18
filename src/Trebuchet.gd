extends Area

"""
A Trebuchet which can attack and be destroyed
"""

signal destroyed(score)

onready var body: Spatial = $"Trebuchet Body"
onready var sling: Spatial = $"Trebuchet Sling"


func attack(distance: float):
	"""
	Lobs a rock at target towards -X, local coordinates
	"""
	pass


func _on_started_attack() -> void:
	"""
	Spawns a rock at beginning of animation
	"""
	pass


func _on_released_attack() -> void:
	"""
	Releases the rock
	"""
	pass


func _on_Trebuchet_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		# If player touches
		emit_signal("destroyed", 10)
		queue_free()
