extends Area2D

@onready var collision = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_hitbox_vertex() -> Array:
	var hit_size = collision.get_shape().get_rect().size
	
	return [global_position, global_position+hit_size]
