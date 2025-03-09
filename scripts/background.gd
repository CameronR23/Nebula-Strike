extends CanvasLayer

@onready var back : TextureRect = $margin_container/back
@onready var planet : TextureRect = $margin_container/planet
@onready var stars : TextureRect = $margin_container/stars

@export var BLUR_LAYERS : Array = [0.0, 0.0, 0.0]

var layers : Array

func _ready() -> void:
	layers = [stars, planet, back]
	
func _process(delta: float) -> void:
	for i in range(len(layers)):
		layers[i].material.set_shader_parameter("step", Vector2(BLUR_LAYERS[i], BLUR_LAYERS[i]))
