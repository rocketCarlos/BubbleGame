extends TileMapLayer

@onready var dirt = $Dirt
@onready var humid_clean_player = $HumidCleaning
@onready var dry_clean_player = $DryCleaning

var initial_dirt: int = 0
var dirt_percentage: float = 0.0
var water_level: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dirt_percentage()
	Globals.clean.connect(_on_clean)
	Globals.mess.connect(_on_mess)
	Globals.water_update.connect(_on_water_update)
	mess_random(25.0)

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
		# check if cell is dirty
		if dirt.get_cell_tile_data(local_to_map(to_local(pos))):
			# if it is, clean only if water
			if water_level > 0.0:
				dirt.erase_cell(local_to_map(to_local(pos)))
				if not humid_clean_player.playing:
					humid_clean_player.play()
			else:
				if not dry_clean_player.playing:
					dry_clean_player.play()
				
		update_dirt_percentage()
	
func _on_mess(cells: Array) -> void:
	for pos in cells:
		if get_cell_tile_data(local_to_map(to_local(pos))):
			dirt.set_cell(local_to_map(to_local(pos)), 0, Vector2i(0,0))
	
	update_dirt_percentage()
	
func _on_water_update(water: float) -> void:
	water_level = water
#endregion
