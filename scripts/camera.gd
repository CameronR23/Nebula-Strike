extends Camera2D  # Use Camera3D if working in 3D

@export var noise_texture: NoiseTexture2D = preload("res://noise/new_noise_texture_2d.tres")  # Assign a noise texture in the inspector
@export var shake_intensity: float = 10.0
@export var shake_duration: float = 0.5
@export var shake_frequency: float = 2000.0

var noise: FastNoiseLite
var shake_timer: float = 0.0
var time_elapsed: float = 0.0

var currentOffsetX = -100.0
var currentOffsetY = 0.0

func _ready():
	self.make_current()
	if noise_texture:
		noise = noise_texture.noise
	else:
		noise = FastNoiseLite.new()
		noise.seed = randi()
		noise.frequency = 1.0

func start_shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = duration
	time_elapsed = 0.0

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		time_elapsed += delta * shake_frequency
		
		var x_offset = noise.get_noise_2d(time_elapsed, 0) * shake_intensity + currentOffsetX
		var y_offset = noise.get_noise_2d(0, time_elapsed) * shake_intensity + currentOffsetY
		
		offset = Vector2(x_offset, y_offset)

		if shake_timer <= 0:
			offset = Vector2(currentOffsetX, currentOffsetY)
	else:
		currentOffsetX = 1150.0
		currentOffsetY = 750
		offset = lerp(Vector2(currentOffsetX, currentOffsetY), offset, delta*50)
