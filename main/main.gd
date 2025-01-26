extends Node2D

@onready var water_icon = $Player/HUD/Container/water

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.no_water.connect(_on_no_water)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_no_water() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(water_icon, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(water_icon, "scale", Vector2(1.0, 1.0), 0.25)
	await tween.step_finished
	for i in range(6):
		if i % 2 == 0:
			water_icon.rotation_degrees = 25
		else:
			water_icon.rotation = -25
		await get_tree().create_timer(0.1).timeout
		
	
