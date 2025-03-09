extends CharacterBody2D

@onready var sprite = $animated_sprite
@onready var col = $area/collision_shape
@onready var explosion : PackedScene = preload("res://scenes/explosion.tscn")
@onready var object_layer : Node2D = get_parent()
@onready var player : CharacterBody2D = get_parent().get_child(1)

@export var SCALE_MULTIPLIER : float = 10.0
@export var SPEED : float = 600.0

const COL_SIZES = [26, 19, 6, 10, 20]

var rng = RandomNumberGenerator.new()
var movement = Vector2(-50, 25*[-1, 1][rng.randi_range(0, 1)])

func _ready() -> void:
	self.scale *= SCALE_MULTIPLIER

func _physics_process(delta: float) -> void:
	if position.y < 10 or position.y > DisplayServer.window_get_size().y-10:
		movement.y *= -1
	col.shape.size.y = COL_SIZES[sprite.frame]
	velocity = movement*delta*SPEED
	if position.x+200 < 0:
		player.damage(-30, Vector2(-1000, -1000))
		self.queue_free()
	move_and_slide()


func _on_area_body_entered(body: Node2D) -> void:
	if "shoot" in body.name:
		body.constant_force = Vector2.ZERO
		body.linear_velocity = Vector2.ZERO
		body.get_child(0).play("flash")
		var particle = explosion.instantiate()
		particle.position = position
		object_layer.add_child(particle)
		self.queue_free()
		self.queue_free()
	elif body.name == "player":
		body.damage(-20, self.position)
		self.queue_free()
