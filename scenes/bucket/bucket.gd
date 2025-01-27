extends Sprite2D

@onready var refill_player = $Refill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globals.clean.emit([global_position])


func _on_area_2d_body_entered(body: Node2D) -> void:
	refill_player.play()
	Globals.refill.emit()
