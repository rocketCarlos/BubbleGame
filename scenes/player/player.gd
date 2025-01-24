extends CharacterBody2D


const MAX_ACCEL: float = 1000.0
const MAX_DEACCEL: float = 

func _ready() -> void:
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
		velocity -= velocity * slippery_factor
		velocity += accel_per_second * direction * delta
		# Limit speed not to exceed MAX_SPEED
		if velocity.length() >= MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * deaccel_per_second * delta
			# Prevent overshooting and stop when speed is very low
			if velocity.length() < 10.0:  # Threshold for stopping
				velocity = Vector2(0, 0)
				
	# -------------------------
	# manage water level
	# -------------------------
	print("water ", water_level)
	print("accel ", accel_per_second)
	print("deaccel ", deaccel_per_second)
	water_level -= velocity.length() * 0.00025
	
	if water_level < 0:
		water_level = 0
	
	update_acceleration()
	
	move_and_slide()

'''
updates accel_per_second and deaccel_per_second depending on the water level
'''
func update_acceleration() -> void:
	#accel_per_second = MAX_ACCEL_PER_SECOND * (water_level / 100.0)
	deaccel_per_second = MAX_DEACCEL_PER_SECOND * ((100.0-water_level) / 100.0)
