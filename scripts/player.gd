extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -1000.0
const MASS = 3.5

var is_action_used: bool = false

@onready var ray_cast: RayCast2D = $RayCast2D

func mega_jump_action():
	velocity.y = JUMP_VELOCITY - 500

func _physics_process(delta: float) -> void:
	# Handling gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * MASS

	# Handling action (to rework)
	if Input.is_action_pressed("action") and ray_cast.is_colliding() and not is_on_floor() and not is_action_used:
		is_action_used = true
		$AnimationPlayer.play("mega_jump")
	
	# Renew action ability to be used
	if Input.is_action_just_released("action"):
		is_action_used = false
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get direction of movement
	var direction := Input.get_axis("left", "right")
	# Handle direction for movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction > 0:
		$PlayerSprite2D.flip_h = false
	elif direction < 0:
		$PlayerSprite2D.flip_h = true

	move_and_slide()
