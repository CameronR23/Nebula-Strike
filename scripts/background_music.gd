extends AudioStreamPlayer

@onready var game_over = $game_over

var alread_played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().get_child(1).name == "game_over" and not game_over.playing and not alread_played:
		self.stop()
		game_over.play()
		alread_played = true
	elif get_parent().get_child(1).name != "game_over" and alread_played:
		self.play()
		alread_played = false

func _on_game_over_finished() -> void:
	pass
