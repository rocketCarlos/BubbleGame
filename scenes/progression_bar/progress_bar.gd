extends TextureProgressBar

@onready var mop = $Mop
@onready var bubbles = $Bubbles

var mop_start: float
var mop_end: float
var already_flipped: bool = false

func _ready() -> void:
	value = 0
	mop_start = mop.position.x
	mop_end = bubbles.position.x - bubbles.sprite_frames.get_frame_texture("default",0).get_width()
	
func _process(delta: float) -> void:
	mop.position.x = lerp(mop_start, mop_end, value / 100.0)
	tint_progress = Color(1-value/100, 1, 1-value/100)
	if int(value) % 5 == 0:
		if not already_flipped:
			mop.flip_h = not mop.flip_h
			already_flipped = true
	else:
		already_flipped = false
		
	if value == 100:
		Globals.stage_cleaned.emit()
