extends KinematicBody
class_name Player

"""
The player, or the Keepalive castle.

The player may move right, deploy into a castle, and go mobile.
The player may move only when mobile, but the player takes quarter damage when deployed.

Currently player can only take damage from rocks.
"""

signal keep_animate_ended
signal hp_changed(new_hp)
signal defeated


export(float) var movement_speed: = 5.0
export(NodePath) var transient: NodePath

var hp: = 100

var _enabled: = false
var _can_walk: = false
var _is_still: = true

var _standing_up: = false
var _deploying: = false

onready var _keep: Spatial = $Keepalive
onready var _anim: AnimationPlayer = $Keepalive/AnimationPlayer
onready var _transient: Spatial = get_node(transient)


func _ready():
	_anim.play("stand_up")
	_anim.stop()


func _physics_process(delta: float) -> void:
	_handle_inputs(delta)


func damage(amount) -> void:
	$DamageSFX.play()
	if _is_still:
		hp -= amount / 4
	else:
		hp -= amount
	emit_signal("hp_changed", hp)
	if hp <= 0:
		_enabled = false
		emit_signal("defeated")
		var cam: Camera = $Camera
		var t = cam.to_global(Vector3(0, 0, 0))
		remove_child(cam)
		_transient.add_child(cam)
		cam.global_translate(t)
		queue_free()


func _handle_inputs(delta: float) -> void:
	if not _enabled:
		if _can_walk:
			_walk_stop()
		return
	var speed: = 0.0
	
	# Precedence: Deploy > Stand > Walk
	if not _is_still && Input.is_action_just_pressed("deploy"):
		_deploy()
	elif not _can_walk && Input.is_action_just_pressed("stand"):
		_stand_up()
	elif Input.is_action_pressed("move_right"):
		speed = movement_speed

	if _can_walk && speed != 0.0:
		move_and_slide(Vector3(speed, 0, 0))
		if _anim.current_animation != "walk_loop":
			_walk_start()
	elif speed == 0.0 && not _is_still:
		_walk_stop()

func _walk_start():
	_anim.play("walk_start")


func _walk_stop():
	if _anim.is_playing() && not ["idle", "stand_up"].has(_anim.current_animation):
	#if _anim.current_animation != "idle" && _anim.current_animation != "stand_up":
		_anim.play("walk_stop")


func _stand_up():
	_deploying = false
	_standing_up = true
	_is_still = false
	_anim.play("stand_up")
	

func _deploy():
	_deploying = true
	_standing_up = false
	_can_walk = false
	_anim.play_backwards("stand_up")


func _on_keep_animate_started() -> void:
	"""
	The keep is animated. Stand up!
	"""
	_stand_up()
	yield(_anim, "animation_finished")
	emit_signal("keep_animate_ended")


func _on_Player_enabled() -> void:
	_enabled = true


func _on_Player_disabled() -> void:
	_enabled = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "stand_up":
		if _standing_up:
			_anim.play("idle")
			_can_walk = true
		elif _deploying:
			_anim.stop()
			_is_still = true
		_standing_up = false
		_deploying = false
	elif anim_name == "walk_start":
		_anim.play("walk_loop")
	elif anim_name == "walk_stop":
		_anim.play("idle")
