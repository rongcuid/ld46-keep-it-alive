extends RigidBody


export(int) var DAMAGE_AMOUNT: = 4
var launched: = false


func _on_Rock_body_entered(body):
	if launched && body.has_method("damage"):
		body.damage(DAMAGE_AMOUNT)
	queue_free()
