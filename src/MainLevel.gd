extends Spatial

signal game_start_animation_began
signal game_started

# Game states
enum {GST_STARTSCREEN, GST_START_ANIMATION, GST_RUNNING, GST_GAMEOVER, GST_VICTORY}

var score: = 0
var _game_state: = GST_STARTSCREEN


func _ready():
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	_handle_input(delta)


func _handle_input(delta: float) -> void:
	match _game_state:
		GST_STARTSCREEN:
			if Input.is_action_just_pressed("ui_accept"):
				_game_state = GST_START_ANIMATION
				$UI/StartScreen.visible = false
				emit_signal("game_start_animation_began")
		_:
			return


func _on_game_start_animation_end():
	_game_state = GST_RUNNING
	emit_signal("game_started")


func _on_enemy_destroyed():
	score += 1
	$UI/Score.text = "SCORE: %i" % score
