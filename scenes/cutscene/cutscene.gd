extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "initial"
	frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("accelerate"):
		if frame == 3:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
			print("hello")
			await tween.finished
			print("ended")
			Globals.start_game.emit()
		frame += 1
		
