extends CharacterBody2D

#region scene nodes
@onready var sprite = $Sprite2D
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
const WATER_DISTANCE: float = 10000.0
var water_level: float = 100.0
var distance_travelled: float = 0.0
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

	# -----------------------------------------
	# manage movement
	# -----------------------------------------
	if Input.is_action_pressed("accelerate"):
		# the acceleration force input by the player
		var force = accel * direction * delta
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
	distance_travelled += velocity.length() * delta
	water_level = clamp(inverse_lerp(WATER_DISTANCE, 0.0, distance_travelled) * 100.0, 0.0, 100.0)
	update_acceleration()
	
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
#endregion
