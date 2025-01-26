extends Node

# the % of cleanness. starts at 0% and level is completed at 100%
var clean_level

# emitted by the bucket when the player enters its area2d to refill water
signal refill

# emitted by the progress bar when the room gets 100% clean
signal stage_cleaned

# emitted by the player to update the water bar
signal water_update(water_level: float)

# emitted by the player to clean tiles
signal clean(positions: Array)

# called by things that mess up tiles
signal mess(positions: Array)

# emitted by player when run out of water
signal no_water()

# emitted by items when broken
signal penalty()

# emitted to start the game
signal start_game()
