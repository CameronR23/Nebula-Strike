extends Node2D

@onready var asteroid : PackedScene = preload("res://scenes/asteroid.tscn")
@onready var enemy : PackedScene = preload("res://scenes/enemy.tscn")
@onready var objects_layer : Node2D = self
@onready var player : CharacterBody2D = get_child(1)

var rng = RandomNumberGenerator.new()
var asteroid_cooldown : float = 0.0
var asteroid_reset : float = 2.0
var asteroid_index : int = 0
var enemy_cooldown : float = 0.0
var enemy_reset : float = 20.0
var enemy_index : int = 0
var glitch_timer : float = 1.0
var number_of_spawns_left : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if number_of_spawns_left > 0:
		if asteroid_cooldown <= 0.0:
			asteroid_cooldown = asteroid_reset
			spawnAsteroid()
			number_of_spawns_left -= 1
		else:
			asteroid_cooldown -= delta
		if enemy_cooldown <= 0.0:
			enemy_cooldown = enemy_reset
			spawnEnemy()
			number_of_spawns_left -= 1
		else:
			enemy_cooldown -= delta
	elif len(get_children()) <= 4:
		player.next_level()
		number_of_spawns_left = player.level*4
		asteroid_reset /= 1.15
		enemy_reset /= 1.15
		
func spawnAsteroid():
	var temp_asteroid = asteroid.instantiate()
	temp_asteroid.position = Vector2(DisplayServer.window_get_size().x+1300, rng.randf_range(100, DisplayServer.window_get_size().y-100))
	temp_asteroid.SIZE = ["small", "big"][rng.randi_range(0, 1)]
	temp_asteroid.name = "asteroid" + str(asteroid_index)
	asteroid_index += 1
	objects_layer.add_child(temp_asteroid)

func spawnEnemy():
	var temp_enemy = enemy.instantiate()
	temp_enemy.position = Vector2(DisplayServer.window_get_size().x+1300, rng.randf_range(100, DisplayServer.window_get_size().y-100))
	temp_enemy.name = "enemy" + str(enemy_index)
	enemy_index += 1
	objects_layer.add_child(temp_enemy)
