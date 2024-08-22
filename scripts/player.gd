extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -1200.0
const MASS = 4

var is_action_used: bool = false

@onready var ray_cast: RayCast2D = $RayCast2D

func ray_cast_colliding():
	velocity.y = JUMP_VELOCITY - 500

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * MASS

	if Input.is_action_pressed("action") and ray_cast.is_colliding() and not is_on_floor() and not is_action_used:
		is_action_used = true
		$AnimationPlayer.play("action_used")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0

	if Input.is_action_just_released("action"):
		is_action_used = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
