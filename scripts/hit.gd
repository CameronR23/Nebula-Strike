extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.frame == 4 and self.animation == "hit") or (self.frame == 5 and self.animation == "explosion"):
		self.queue_free()
