extends Node

# the % of cleanness. starts at 0% and level is completed at 100%
var clean_level

# emitted by the bucket when the player enters its area2d to refill water
signal refill

# emitted by the progress bar when the room gets 100% clean
signal stage_cleaned
