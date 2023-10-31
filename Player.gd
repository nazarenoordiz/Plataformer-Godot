extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -270.0

const JUMP_BACK = 240
const WALL_SLIDE = 60

const FRICTION: int = 40
const ACCELERATION: int = 30


# Get the gravity from the project settings to be synced with RigidBody nodes.
const gravity = 600
var last_jump_situation = null

# coyote time
var coyote_timer = 0.0
var coyote_time = 0.14
var has_jumped = false

func _physics_process(delta):
	# variables
	var direction = Input.get_axis("move_left", "move_right")
	jump(delta, direction)
	move_and_animations(direction)
	wall_slide(delta, direction)

	move_and_slide()
	

func jump(delta, direction):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# coyote time
	if is_on_floor():
		coyote_timer = 0.0
		has_jumped = false
	else:
		coyote_timer += delta
		
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or ( !is_on_wall() and coyote_timer < coyote_time and !has_jumped):
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump")
			$JumpSfx.play()
			has_jumped = true
		if is_on_wall() and direction == 1: 
			velocity.y = JUMP_VELOCITY
			velocity.x = -JUMP_BACK
			$AnimatedSprite2D.play("wall_slide")
			$JumpSfx.play()
		elif is_on_wall() and direction == -1: 
			velocity.y = JUMP_VELOCITY
			velocity.x = JUMP_BACK
			$AnimatedSprite2D.play("wall_slide")
			$JumpSfx.play()
	if Input.is_action_just_released("jump") and velocity.y < -100:
		velocity.y = -100
		
func move_and_animations(direction):
	if direction:
		accelerate(direction)
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")
		particles(false, false, direction)
		apply_friction()
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
		if is_on_wall():
			$AnimatedSprite2D.play("wall_slide")
			$AnimatedSprite2D.flip_h = true
			particles(false, false, direction)
			if direction == -1:
				$AnimatedSprite2D.flip_h = false
		
func particles(run_emitting, walk_emitting, direction):
	$RunParticle.emitting = run_emitting
	$WalkParticle.emitting = walk_emitting
	$WalkParticle.position = Vector2(-11, 0)
	$RunParticle.position = Vector2(-11, 0)
	if direction == -1: 
		$WalkParticle.position = Vector2(11, 0)
		$RunParticle.position = Vector2(11, 0)
		
func wall_slide(delta, direction):
	var is_wall_sliding = false
	if is_on_wall() and not is_on_floor():
		if direction:
			is_wall_sliding = true
	
	if is_wall_sliding and direction == 1:
		velocity.y += WALL_SLIDE*delta
		velocity.y = min(velocity.y, WALL_SLIDE)
	elif is_wall_sliding and direction == -1:
		velocity.y += WALL_SLIDE*delta
		velocity.y = min(velocity.y, WALL_SLIDE)
	
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func accelerate(direction):
	var final_direction = direction/2
	particles(false, true, direction)
	if Input.is_action_pressed("run"):
		particles(true, false, direction)
		final_direction = direction
	velocity.x = move_toward(velocity.x, final_direction * SPEED, ACCELERATION)
