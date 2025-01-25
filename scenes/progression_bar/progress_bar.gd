extends TextureProgressBar

@onready var mop = $Mop
@onready var bubbles = $Bubbles

var mop_start

func _ready() -> void:
	value = 0
	mop_start = mop.position.x
	
func _process(delta: float) -> void:
	mop.position.x = lerp(mop_start, bubbles.position.x, value / 100.0)
	
	if value == 100:
		Globals.stage_cleaned.emit()
