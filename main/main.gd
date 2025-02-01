extends Node2D

@onready var water_icon = $Player/HUD/Container/water
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var breaking_sound = $BreakingPlayer
@onready var clock = $Player/HUD/Container/Clock/Timer
@onready var music = $BackgroundMusic

const MIN_SPEED = 0
@onready var MAX_SPEED = player.MAX_SPEED
var MIN_ZOOM = 0.9
var MAX_ZOOM = 1.1

const GOLD_VICTORY = 200
const GOLD_EXTRA_PER_SECOND = 2
const GOLD_PENALTY = -20
const GOLD_GOAL = 200
var penalties: int = 0
var money: float = 0.0

var final_type: String = ''

var level_ended: bool = false

# Called when thecheats node enters the scene tree for the first time.
func _ready() -> void:
	Globals.no_water.connect(_on_no_water)
	Globals.penalty.connect(_on_penalty)
	Globals.stage_cleaned.connect(_on_level_ended)
	Globals.timed_out.connect(_on_level_ended)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not level_ended:
		var vel_factor = Tween.interpolate_value(0.0, 1.0, player.velocity.length(), MAX_SPEED, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		#var vel_factor = Tween.interpolate_value(0.0, 1.0, player.velocity.length(), MAX_SPEED, Tween.TRANS_BACK, Tween.EASE_IN)
		var zoom = lerp(MIN_ZOOM, MAX_ZOOM, vel_factor)
		camera.zoom = Vector2(zoom, zoom)

#region signal functions
func _on_penalty() -> void:
	penalties += 1
	breaking_sound.play()

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

func _on_level_ended() -> void:
	level_ended = true
	if Globals.clean_level < 100:
		final_type = 'loss'
	else:
		money = GOLD_VICTORY + GOLD_EXTRA_PER_SECOND * clock.time_left + GOLD_PENALTY * penalties
		print(money)
		if money >= GOLD_GOAL:
			final_type = 'success_and_money'
		else:
			final_type = 'success_no_money'

	player.call_deferred("queue_free")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.44, 0.44, 0.44), 1)
	tween.parallel().tween_property(music, "volume_db", -24, 1)
	Globals.game_ended.emit()
	
#endregion
