extends Spatial

signal game_start_animation_began
signal game_started

# Game states
enum {GST_STARTSCREEN, GST_START_ANIMATION, GST_RUNNING, GST_GAMEOVER, GST_VICTORY}

var score: = 0
var _game_state: = GST_STARTSCREEN


func _ready():
	set_physics_process(true)
	for e in $Enemies.get_children():
		e.connect("destroyed", self, "_on_enemy_destroyed")
		connect("game_started", e, "_on_game_started")
		if e.has_method("set_transient"):
			e.set_transient($Transient)


func _physics_process(delta: float) -> void:
	_handle_input(delta)


func _handle_input(delta: float) -> void:
	match _game_state:
		GST_STARTSCREEN:
			if Input.is_action_just_pressed("ui_accept"):
				_game_state = GST_START_ANIMATION
				$UI/StartScreen.visible = false
				emit_signal("game_start_animation_began")
		GST_VICTORY, GST_GAMEOVER:
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				get_tree().reload_current_scene()
		_:
			return


func _on_game_start_animation_end():
	_game_state = GST_RUNNING
	emit_signal("game_started")


func _on_enemy_destroyed(s):
	score += s
	$UI/Score.text = "SCORE: %d" % score


func _on_victory():
	$Player._enabled = false
	$UI/Victory.visible = true
	_game_state = GST_VICTORY


func _on_Player_hp_changed(new_hp):
	$UI/HealthBar/Health.value = clamp(new_hp, 0, 100)


func _on_Player_defeated():
	$UI/GameOver.visible = true
	_game_state = GST_GAMEOVER
