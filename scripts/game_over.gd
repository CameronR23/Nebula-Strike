extends Node2D

@onready var main : PackedScene = load("res://scenes/main.tscn")
@onready var main_menu : PackedScene = load("res://scenes/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_down() -> void:
	get_tree().root.add_child(main.instantiate())
	self.queue_free()


func _on_main_menu_button_down() -> void:
	get_tree().root.add_child(main_menu.instantiate())
	self.queue_free()


func _on_quit_button_down() -> void:
	get_tree().quit()
