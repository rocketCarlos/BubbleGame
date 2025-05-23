extends CharacterBody2D

#region scene nodes
@onready var sprite = $Sprite2D
@onready var mop = $CleaningPoints
@onready var cleaning_point_1 = $CleaningPoints/Point1
@onready var cleaning_point_2 = $CleaningPoints/Point2
@onready var cleaning_point_3 = $CleaningPoints/Point3
@onready var cleaning_point_4 = $CleaningPoints/Point4
@onready var cleaning_point_5 = $CleaningPoints/Point5
@onready var cleaning_point_6 = $CleaningPoints/Point6
@onready var cleaning_point_7 = $CleaningPoints/Point7
@onready var cleaning_point_8 = $CleaningPoints/Point8
@onready var dry_steps_player = $DrySetpsPlayer
@onready var humid_steps_player = $HumidStepsPlayer
@onready var slip_steps_player = $SlipSetpsPlayer
@onready var bump_player = $BumpPlayer
@onready var step_timer = $StepWait
@onready var bubble_timer = $BubbleWait
@onready var bump_timer = $BumpWait
@onready var no_water_player = $NoWater
#endregion 

#region attributes
const MAX_SPEED = 300.0

const MAX_ACCEL: float = 1000.0
const MIN_ACCEL: float = 200.0
var accel: float = MIN_ACCEL

const MAX_DEACCEL: float = 1000.0
const MIN_DEACCEL: float = 200.0
var deaccel: float = MIN_DEACCEL
# measures how slippery the surface is. 
# The higher, the more inertia there is
# max is 1.0
const MIN_SLIPPERY: float = 0.96
var slippery_factor: float = 1.0

# the distance to be covered before losing all water
const WATER_DISTANCE: float = 5000.0
var water_level: float = 100.0
var distance_travelled: float = 0.0

var step_wait: bool = false
var bump_wait: bool = false

var mop_positions: Dictionary = {
	"up": Vector2(0, -6),
	"up_right": Vector2(46, 12),
	"right": Vector2(63, 35),
	"down_right": Vector2(51, 62),
	"down": Vector2(-2, 73),
	"down_left": Vector2(-56, 63),
	"left": Vector2(-95, 34),
	"up_left": Vector2(-58, 5),
}

var cleaning_points : Array 

@export var bubble_scene: PackedScene
var buble_wait: bool = false

var playing_slip: bool = false
#endregion

func _ready() -> void:
	Globals.refill.connect(_on_refill)
	update_acceleration()
	

func _physics_process(delta: float) -> void:
	# ---------------------------------------------
	# manage sprite rotation
	# ---------------------------------------------
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var angle = direction.angle_to(Vector2(1.0, 0.0))
	
	var step = (2.0*PI)/(8.0*2.0)
	
	if abs(angle) < step: # looking right
		sprite.animation = "right"
	elif abs(angle) < (3.0*step):
		if angle > 0.0:
			sprite.animation = "up_right"
		else:
			sprite.animation = "down_right"
	elif abs(angle) < (5.0*step):
		if angle > 0.0:
			sprite.animation = "up"
		else:
			sprite.animation = "down"
	elif abs(angle) < (7.0*step):
		if angle > 0.0:
			sprite.animation = "up_left"
		else:
			sprite.animation = "down_left"
	elif abs(angle) < (8.0*step):
		sprite.animation = "left"
	
	if playing_slip:
		# also put the slip animation
			match sprite.animation:
				"up":
					sprite.play("slip_up")
				"up_right":
					sprite.play("slip_up_right")
				"right":
					sprite.play("slip_right")
				"down_right":
					sprite.play("slip_down_right")
				"down":
					sprite.play("slip_down")
				"down_left":
					sprite.play("slip_down_left")
				"left":
					sprite.play("slip_left")
				"up_left":
					sprite.play("slip_up_left")
	
	if velocity.length() > 0:
		sprite.play()
		# spawn bubbles
		if randf() < water_level/100.0 and not buble_wait:
			buble_wait = true
			bubble_timer.start()
			var bubble = bubble_scene.instantiate()
			match sprite.animation:
				"up":
					bubble.global_position = cleaning_point_5.global_position
				"up_right":
					bubble.global_position = cleaning_point_6.global_position
				"right":
					bubble.global_position = cleaning_point_6.global_position
				"down_right":
					bubble.global_position = cleaning_point_8.global_position
				"down":
					bubble.global_position = cleaning_point_1.global_position
				"down_left":
					bubble.global_position = cleaning_point_2.global_position
				"left":
					bubble.global_position = cleaning_point_4.global_position
				"up_left":
					bubble.global_position = cleaning_point_4.global_position
			
			bubble.scale = Vector2(0.05, 0.05)
			call_deferred("add_sibling", bubble)
	else:
		sprite.stop()
	#mop.position = mop_positions[sprite.animation]
	# -----------------------------------------
	# manage movement and camera
	# -----------------------------------------
	var force =  Vector2(0.0, 0.0)
	if Input.is_action_pressed("accelerate"):
		# the acceleration force input by the player
		force = accel * direction * delta
		# apply the force to velocity
		velocity += force
		# decide based on the slippery factor how important is the new force's
		# direction in the final velocity. To do so, split the velocity's length
		# into proportional parts for each direction (the original and the new)
		velocity = (velocity.length()*slippery_factor) * velocity.normalized() + (velocity.length()*(1.0-slippery_factor)) * force.normalized()
		
		# Limit speed not to exceed MAX_SPEED
		if velocity.length() >= MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * deaccel * delta
			# Prevent overshooting and stop when speed is very low
			if velocity.length() < 10.0:  # Threshold for stopping
				velocity = Vector2(0, 0)
				
	# -------------------------
	# manage water level
	# -------------------------
	# water level linearly decreases as distance_travelled increases
	distance_travelled += get_real_velocity().length() * delta
	var water_just_empty = false if water_level == 0 else true
	water_level = clamp(inverse_lerp(WATER_DISTANCE, 0.0, distance_travelled) * 100.0, 0.0, 100.0)
	if water_level == 0 and water_just_empty:
		no_water_player.play()
		Globals.no_water.emit()
		
		
	Globals.water_update.emit(water_level)
	update_acceleration()
	
	# ------------------
	# manage cleaning
	# -------------------
	# cleans if enough water
	cleaning_points = [
		cleaning_point_1.global_position,
		cleaning_point_2.global_position,
		cleaning_point_3.global_position,
		cleaning_point_4.global_position,
		cleaning_point_5.global_position,
		cleaning_point_6.global_position,
		cleaning_point_7.global_position,
		cleaning_point_8.global_position,
		]
	
	Globals.clean.emit(cleaning_points)
		
	# -------------------------------------
	# manage sound
	# -------------------------------------
	if not humid_steps_player.playing and velocity.length() > 0.1 and not step_wait:
		step_wait = true
		var wait_time = 0.2
		# choose whether to play the slip sound or the normal steps
		if abs(velocity.angle_to(force)) > PI/3.0 and velocity.length() > MAX_SPEED/1.3: # play slip
			slip_steps_player.play()
			playing_slip = true				
			wait_time = 1.0
		elif randf() > (water_level / 100.0): # play steps, dry or humid
			dry_steps_player.play()
		else:
			humid_steps_player.play()
			
		step_timer.start(wait_time)
		
	if get_last_slide_collision() and not bump_player.playing and not bump_wait and get_real_velocity().length() > 25:
		bump_wait = true
		bump_timer.start()
		bump_player.play()
	
	move_and_slide()

#region utility functions
'''
updates accel and deaccel depending on the water level
'''
func update_acceleration() -> void:
	# TODO: explore easing for values
	slippery_factor = lerp(MIN_SLIPPERY, 1.0, water_level/100.0)
	accel = lerp(MAX_ACCEL, MIN_ACCEL, water_level/100.0)
	deaccel = lerp(MAX_DEACCEL, MIN_DEACCEL, water_level/100.0)

#endregion

#region signal functions
func _on_refill() -> void:
	water_level = 100.0
	distance_travelled = 0.0
	
func _on_step_wait_timeout() -> void:
	step_wait = false
	playing_slip = false

func _on_bubble_wait_timeout() -> void:
	buble_wait = false
	
func _on_bump_wait_timeout() -> void:
	bump_wait = false
#endregion
