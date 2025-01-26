extends RigidBody2D

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_trans(tween.TRANS_EXPO)
	
	await tween.finished
	queue_free()


func _on_tree_exiting() -> void:
	Globals.mess.emit([global_position])
