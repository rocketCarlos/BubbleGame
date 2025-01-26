extends Node2D

@onready var water_icon = $Player/HUD/Container/water
@onready var player = $Player
@onready var camera = $Player/Camera2D


const MIN_SPEED = 0
@onready var MAX_SPEED = player.MAX_SPEED
var MIN_ZOOM = 0.9
var MAX_ZOOM = 1.1

# Called when thecheats node enters the scene tree for the first time.
func _ready() -> void:
	Globals.no_water.connect(_on_no_water)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel_factor = Tween.interpolate_value(0.0, 1.0, player.velocity.length(), MAX_SPEED, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	#var vel_factor = Tween.interpolate_value(0.0, 1.0, player.velocity.length(), MAX_SPEED, Tween.TRANS_BACK, Tween.EASE_IN)
	var zoom = lerp(MIN_ZOOM, MAX_ZOOM, vel_factor)
	camera.zoom = Vector2(zoom, zoom)

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
		
	
