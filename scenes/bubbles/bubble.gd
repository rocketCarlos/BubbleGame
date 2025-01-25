extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match randi_range(0, 2):
		0: play('big')
		1: play('medium')
		2: play('small')
	var height = -sprite_frames.get_frame_texture("big",0).get_height() * scale.y
	position = Vector2(position.x + randf_range(-height, height), position.y + randf_range(-height, height))
	var duration_factor = randf()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5+1.5*duration_factor).set_trans(Tween.TRANS_EXPO)
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(position.x, position.y + height + (height/2)*randf()), 0.5+1.5*duration_factor)
	await tween.finished
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
