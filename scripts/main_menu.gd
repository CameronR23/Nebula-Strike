extends Node2D

@onready var main : PackedScene = preload("res://scenes/main.tscn")
@onready var background_music : PackedScene = preload("res://scenes/background_music.tscn")
@onready var anim : AnimationPlayer = $CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_down() -> void:
	anim.play("exit")
	

func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().root.add_child(main.instantiate())
	if len(get_tree().root.get_children()) <= 2:
		get_tree().root.add_child(background_music.instantiate())
	self.queue_free()
