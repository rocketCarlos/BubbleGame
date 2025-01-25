extends TileMapLayer

@onready var dirt = $Dirt

var dirt_percentage: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dirt_percentage()
	print(dirt_percentage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_dirt_percentage() -> void:
	# get dirty cells
	print(dirt.get_used_cells().size(), " ", get_used_cells().size())
	dirt_percentage = (float(dirt.get_used_cells().size()) / float(get_used_cells().size()))*100.0
