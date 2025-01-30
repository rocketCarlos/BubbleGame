extends Node

# the % of cleanness. starts at 0% and level is completed at 100%
var clean_level

# informs about the current level. With each level, the difficulty increases
# meaning that less time and more dirty cells
var level: int = 0

# values for the final menu money description
var final_menu_values: Dictionary

# emitted by the bucket when the player enters its area2d to refill water
signal refill

# emitted by the progress bar when the room gets 100% clean
signal stage_cleaned

# emitted by the clock when the timer gets to 0
signal timed_out

# emitted by the main scene to inform the game controler that the game has ended
signal game_ended

# emitted by the player to update the water bar
signal water_update(water_level: float)

# emitted by the player to clean tiles
signal clean(positions: Array)

# called by things that mess up tiles
signal mess(positions: Array)

# emitted by player when run out of water
signal no_water

# emitted by items when broken
signal penalty

# emitted to start the game
signal start_game

# emitted by the final menu to go to the final screen
signal title_screen

# emitted by the final menu to advance to the final cutscene
signal buy_bubble_maker
