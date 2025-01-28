extends TextureProgressBar

@onready var timer = $Timer
@onready var minute = $Minute

@export var total_time: int = 60
var rotation_offset = 2.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# dinamically set the total time depending on the level
	total_time = lerp(120.0, 60.0, inverse_lerp(0, 5, Globals.level))
	timer.start(total_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = inverse_lerp(total_time, 0, timer.time_left) * 100.0
	minute.rotation = lerp(0.0, 2*PI, value/100.0) + rotation_offset * PI / 180 
