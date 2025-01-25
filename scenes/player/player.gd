extends CharacterBody2D

const MAX_SPEED = 300.0

const MAX_ACCEL: float = 1000.0
const MIN_ACCEL: float = 200.0
var accel: float = MIN_ACCEL

const MAX_DEACCEL: float = 1000.0
const MIN_DEACCEL: float = 200.0
var deaccel: float = MIN_DEACCEL
# measures how slippery the surface is. 
# The higher, the more inertia there is
# between 0 and 1
var slippery_factor: float = 1.0

# between 0 and 100
var water_level: float = 100.0

func _ready() -> void:
	Globals.refill.connect(_on_refill)
	update_acceleration()

func _physics_process(delta: float) -> void:
	# -----------------------------------------
	# rotate the duck to point towars the mouse
	# -----------------------------------------
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	rotation = Vector2(0.0, 1.0).angle_to(direction)
	
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
	water_level -= velocity.length() * 0.00025
	
	if water_level < 0:
		water_level = 0
	
	update_acceleration()
	
	move_and_slide()

#region utility functions
'''
updates accel and deaccel depending on the water level
'''
func update_acceleration() -> void:
	# TODO: explore easing for values
	slippery_factor = lerp(0.96, 1.0, water_level/100.0)
	accel = lerp(MAX_ACCEL, MIN_ACCEL, water_level/100.0)
	deaccel = lerp(MAX_DEACCEL, MIN_DEACCEL, water_level/100.0)
	print(accel, " ", deaccel, " ", water_level)
#endregion

#region signal functions
func _on_refill() -> void:
	water_level = 100.0
#endregion
