extends CharacterBody2D


const SPEED = 300.0
const SPEED_ATTACK = 2200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State { STATE_JUMPING, STATE_IDLE, STATE_RUNNING, STATE_FALLING, STATE_ATTACK }

# Déclaration explicite du type
var current_state: State = State.STATE_IDLE
var facing_right := true

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if facing_right:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	
	if Input.is_action_just_pressed("ui_left"):
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		State.STATE_FALLING:
			print(current_state)
			if is_on_floor():
				current_state = State.STATE_IDLE
				animated_sprite.play("Idle")
			elif not is_on_floor && direction != 0:
				current_state = State.STATE_RUNNING
				animated_sprite.play("run")
		State.STATE_RUNNING:
			print(current_state)
			velocity.x = direction * SPEED
			print(direction)
			if direction > 0:
				facing_right = true
			elif direction < 0:
				facing_right = false
			else:
				current_state = State.STATE_IDLE
				animated_sprite.play("idle")
		State.STATE_IDLE:
			if direction != 0:
					current_state = State.STATE_RUNNING
					animated_sprite.play("run")
			elif Input.is_action_just_pressed("ui_accept"):
				current_state = State.STATE_JUMPING
				velocity.y = -JUMP_VELOCITY
				animated_sprite.play("jump")
			elif Input.is_action_just_pressed("attack"):
				current_state = State.STATE_ATTACK
				velocity.x = SPEED * 1
				animated_sprite.play("attack")
			elif not is_on_floor() and velocity.y > 0:
					current_state = State.STATE_FALLING
					animated_sprite.play("fall")
		State.STATE_JUMPING:
			if velocity.y >= 0:			
				current_state = State.STATE_FALLING 
				velocity.y = JUMP_VELOCITY
				animated_sprite.play("fall")
			else:
				animated_sprite.play("jump")
		State.STATE_ATTACK:
			print(velocity.x)
			velocity.x =  move_toward( velocity.x, 0.0, SPEED_ATTACK * delta)
			# animated_sprite.play("attack")			
			if not animated_sprite.is_playing():
				current_state = State.STATE_IDLE
				velocity.x = 0
				animated_sprite.play("idle")

		_:
			animated_sprite.play("idle")

			print(current_state)

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	
	# if direction:
	# 	velocity.x = direction * SPEED
	# 	animated_sprite.play("run")
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)
	# 	animated_sprite.play("idle")

	animated_sprite.flip_h = direction < 0

	move_and_slide()
