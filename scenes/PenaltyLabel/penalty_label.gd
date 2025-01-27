extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello label")
	var tween = get_tree().create_tween()
	# 15º degrees
	tween.tween_property(self, "rotation", 0.261799, 1)
	tween.parallel().tween_property(self, "position", Vector2(position.x, position.y - 50.0), 1)
	tween.parallel().tween_property(self, "scale", Vector2(scale.x + 0.15, scale.y + 0.15), 1)
	await tween.finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
