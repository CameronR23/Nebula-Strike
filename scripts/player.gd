extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $animated_sprite
@onready var hit : PackedScene = preload("res://scenes/hit.tscn")
@onready var explosion : PackedScene = preload("res://scenes/explosion.tscn")
@onready var shoot : PackedScene = preload("res://scenes/shoot.tscn")
@onready var object_layer : Node2D = get_parent()
@onready var hit_sound : AudioStreamPlayer2D = $audio_stream_player_hit
@onready var shot1_sound : AudioStreamPlayer2D = $audio_stream_player_shot1
@onready var shot2_sound : AudioStreamPlayer2D = $audio_stream_player_shot2
@onready var explosion_sound : AudioStreamPlayer2D = $audio_steam_player_explosion
@onready var camera : Camera2D = get_parent().get_child(2)
@onready var bar : ProgressBar = get_parent().get_child(3).get_child(0).get_child(0)
@onready var level_text : Label = get_parent().get_child(3).get_child(1).get_child(0)
@onready var game_over : PackedScene = preload("res://scenes/game_over.tscn")

@export var SCALE_MULTIPLIER : float = 10.0
@export var SPEED : float = 300.0
@export var OFFSET_X : float = 200.0
@export var ACCELERATION : float = 50.0
@export var DRAG : float = 0.9
@export var STARTING_HEALTH : float = 100.0
@export var SHOOT_RESET : float = 1.0

var rng = RandomNumberGenerator.new()
var movement : Vector2
var health : float
var shoot_cooldown : float = 0.0
var shoot_array : Array = []
var shoot_index : int = 0
var level : int = 1
var level_opacity : float = 2.0

func _ready() -> void:
	self.scale *= SCALE_MULTIPLIER
	health = STARTING_HEALTH

func next_level():
	level += 1
	level_text.text = "Level " + str(level)
	level_opacity = 2.0

func _physics_process(delta: float) -> void:
	if level_opacity > 0:
		level_opacity -= delta
		level_text.label_settings.font_color = Color(255,255,255,level_opacity)
		level_text.label_settings.shadow_color = Color(0,0,0,level_opacity)
	# Handle quit
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	# Handle health bar
	bar.value = health
	if health >= 100:
		health = 100
	elif health <= 0:
		get_tree().root.add_child(game_over.instantiate())
		object_layer.queue_free()
	
	# Handle movement
	movement = Vector2(0, Input.get_axis("up", "down"))
	
	# Set animation
	match movement.y:
		1.0:
			sprite.animation = "top"
		-1.0:
			sprite.animation = "bottom"
		0.0:
			sprite.animation = "side"
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot") and shoot_cooldown:
		health -= 10
		camera.start_shake(15, 0.1)
		[shot1_sound, shot2_sound][rng.randi_range(0, 1)].play()
		shoot_cooldown = SHOOT_RESET
		var temp_shoot = shoot.instantiate()
		temp_shoot.position = self.position
		temp_shoot.name = "shoot" + str(shoot_index)
		shoot_index += 1
		shoot_array.append(temp_shoot)
		object_layer.add_child(temp_shoot)
	else:
		shoot_cooldown -= delta
	for i in range(len(shoot_array)):
		if len(shoot_array)-1 >= i:
			if shoot_array[i].position.x > DisplayServer.window_get_size().x+1300:
				shoot_array[i].queue_free()
				shoot_array.pop_at(i)
			elif shoot_array[i].get_child(0).animation == "flash" and shoot_array[i].get_child(0).frame == 1:
				camera.start_shake(30, 0.3)
				health += 15
				shoot_array[i].queue_free()
				shoot_array.pop_at(i)
				explosion_sound.play()
	
	# Move self
	self.velocity += movement * SPEED * ACCELERATION * delta
	self.velocity *= DRAG
	self.position.x = OFFSET_X
	
	move_and_slide()

func damage(amount, location):
	camera.start_shake(50*amount/10, 0.3)
	if amount == -10:
		hit_sound.play()
		var particle = hit.instantiate()
		particle.position = location
		object_layer.add_child(particle)
	else:
		explosion_sound.play()
		var particle = explosion.instantiate()
		particle.position = location
		object_layer.add_child(particle)
	health += amount
