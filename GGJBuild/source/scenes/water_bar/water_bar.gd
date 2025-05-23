extends TextureProgressBar

var mop_start: float
var mop_end: float
var already_flipped: bool = false

func _ready() -> void:
	Globals.water_update.connect(_on_water_update)
	value = 100
	
func _process(delta: float) -> void:
	pass

func _on_water_update(water_level: float) -> void:
	value = water_level
	tint_progress = Color(lerp(0.0, 0.292, value/100.0), lerp(0.421, 0.933, value/100.0), lerp(0.43, 1.0, value/100.0))
