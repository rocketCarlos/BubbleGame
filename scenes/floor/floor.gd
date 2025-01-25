extends TileMapLayer

@onready var dirt = $Dirt

var dirt_percentage: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dirt_percentage()
	Globals.clean.connect(_on_clean)
	Globals.mess.connect(_on_mess)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_dirt_percentage() -> void:
	# get dirty cells
	dirt_percentage = (float(dirt.get_used_cells().size()) / float(get_used_cells().size()))*100.0

func _on_clean(cells: Array) -> void:
	for pos in cells:
		dirt.erase_cell( local_to_map(to_local(pos)) )
	update_dirt_percentage()
	
func _on_mess(cells: Array) -> void:
	for pos in cells:
		dirt.set_cell(local_to_map(to_local(pos)), 0, Vector2i(0,0))
	
