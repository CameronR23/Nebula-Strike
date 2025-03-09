extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $animated_sprite
@onready var col : CollisionShape2D = $area/collision_shape
@onready var hit : PackedScene = preload("res://scenes/hit.tscn")
@onready var object_layer : Node2D = get_parent()
@onready var player : CharacterBody2D = get_parent().get_child(1)

@export var SCALE_MULTIPLIER : float = 10.0
@export var SPEED : float = 300.0
@export var SMALL_RADIUS : float = 5.0
@export var BIG_RADIUS : float = 15.0
@export var SIZE : String = "small"

var movement : Vector2 = Vector2(-2, 0)

func _ready() -> void:
	col.shape = col.shape.duplicate()
	self.scale *= SCALE_MULTIPLIER
	sprite.animation = SIZE
	if SIZE == "small":
		col.shape.radius = SMALL_RADIUS
	else:
		col.shape.radius = BIG_RADIUS

func _physics_process(delta: float) -> void:
	position += movement*delta*SPEED
	if position.x+200 < 0:
		player.damage(-30, Vector2(-1000, -1000))
		self.queue_free()

	move_and_slide()


func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if SIZE == "small":
			body.damage(-10, self.position)
		else:
			body.damage(-30, self.position)
		self.queue_free()
	elif "shoot" in body.name:
		body.constant_force = Vector2.ZERO
		body.linear_velocity = Vector2.ZERO
		body.get_child(0).play("flash")
		var particle = hit.instantiate()
		particle.position = position
		object_layer.add_child(particle)
		self.queue_free()


func _on_area_area_entered(area: Area2D) -> void:
	pass
