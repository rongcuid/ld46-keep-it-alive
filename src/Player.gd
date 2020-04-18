extends KinematicBody
class_name Player

signal keep_animate_ended


export(float) var movement_speed: = 100.0

var _enabled: = false
onready var _keep: Spatial = $Keepalive
onready var _anim: AnimationPlayer = $Keepalive/AnimationPlayer


func _ready():
	_anim.play("stand_up")
	_anim.stop()


func _process(delta: float) -> void:
	_handle_inputs(delta)


func _handle_inputs(delta: float) -> void:
	if not _enabled:
		return
	var speed: = 0.0
	if Input.is_action_pressed("move_left"):
		speed -= movement_speed
	if Input.is_action_pressed("move_right"):
		speed += movement_speed
	move_and_slide(Vector3(speed, 0, 0))


func _on_keep_animate_started() -> void:
	"""
	The keep is animated. Stand up!
	"""
	_anim.play("stand_up")
	yield(_anim, "animation_finished")
	emit_signal("keep_animate_ended")


func _on_Player_enabled() -> void:
	_enabled = true


func _on_Player_disabled() -> void:
	_enabled = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "stand_up":
		_anim.play("idle")
	elif anim_name == "walk_start":
		_anim.play("walk_loop")
	elif anim_name == "walk_stop":
		_anim.play("walk_stop")
