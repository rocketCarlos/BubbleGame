extends TileMapLayer

@onready var dirt = $Dirt

var initial_dirt: int = 0
var dirt_percentage: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dirt_percentage()
	Globals.clean.connect(_on_clean)
	Globals.mess.connect(_on_mess)
	mess_random(50.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region utility functions
func update_dirt_percentage() -> void:
	# get dirty cells
	dirt_percentage = (float(dirt.get_used_cells().size()) / initial_dirt)*100.0
	Globals.clean_level = 100.0 - dirt_percentage
	
func mess_random(percentage: float) -> void:
	for cell in get_used_cells():
		if randf() < percentage / 100.0:
			dirt.set_cell(cell, 0, Vector2i(0,0))
			initial_dirt += 1
#endregion
			
#region signal functions
func _on_clean(cells: Array) -> void:
	for pos in cells:
		dirt.erase_cell( local_to_map(to_local(pos)) )
	update_dirt_percentage()
	
func _on_mess(cells: Array) -> void:
	for pos in cells:
		dirt.set_cell(local_to_map(to_local(pos)), 0, Vector2i(0,0))
	update_dirt_percentage()
#endregion
