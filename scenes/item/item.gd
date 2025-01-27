extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var breaking_player = $BreakingPlayer

@export var label_scene: PackedScene

var already_hit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if not already_hit:
		already_hit = true
		Globals.penalty.emit()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_trans(tween.TRANS_EXPO)
		await get_tree().create_timer(0.25).timeout
		breaking_player.play()
		await tween.finished
		breaking_player.play()
		var label = label_scene.instantiate()
		label.global_position = global_position
		call_deferred("add_sibling", label)
		queue_free()


func _on_tree_exiting() -> void:
	Globals.mess.emit([global_position])
	
