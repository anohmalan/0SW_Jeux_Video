extends CharacterBody2D


const SPEED = 300.0
const SPEED_ATTACK = 2200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State { STATE_JUMPING, STATE_IDLE, STATE_RUNNING, STATE_FALLING, STATE_ATTACK }

# Déclaration explicite du type
var current_state: State = State.STATE_IDLE
var facing_right := true
var direction:= 0.0


func _physics_process(delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	handle_state_transitions()

	match current_state:
		State.STATE_FALLING:
			fall()
		State.STATE_RUNNING:
			run()
		State.STATE_IDLE:
			idle()
		State.STATE_JUMPING:
			jump()
		State.STATE_ATTACK:
			attack(delta)
		_:
			idle()
	
	dir()
	move_and_slide()

func handle_state_transitions() -> void:
	if current_state == State.STATE_ATTACK:
		return

	if not is_on_floor():
		if velocity.y < 0:
			current_state = State.STATE_JUMPING
		else:
			current_state = State.STATE_FALLING
		return

	if Input.is_action_just_pressed("attack"):
		current_state = State.STATE_ATTACK
		velocity.x = SPEED * (1 if facing_right else -1)
		animated_sprite.play("attack")
		return

	if Input.is_action_just_pressed("ui_accept"):
		current_state = State.STATE_JUMPING
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
		return

	if direction != 0:
		current_state = State.STATE_RUNNING
	else:
		current_state = State.STATE_IDLE

func attack(delta: float) -> void:
	velocity.x =  move_toward( velocity.x, 0.0, SPEED_ATTACK * delta)
	if not animated_sprite.is_playing():
		current_state = State.STATE_IDLE
		velocity.x = 0
		animated_sprite.play("idle")

func jump() -> void:
	if velocity.y >= 0:			
		current_state = State.STATE_FALLING 
		animated_sprite.play("fall")
	else:
		velocity.x = direction * SPEED
		animated_sprite.play("jump")

func fall() -> void:
	velocity.x = direction * SPEED
	animated_sprite.play("fall")

func run() -> void:
	velocity.x = direction * SPEED
	animated_sprite.play("run")


func idle() -> void:
	velocity.x = move_toward(velocity.x, 0.0, SPEED)
	animated_sprite.play("idle")
		
func dir() -> void:
	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false
	animated_sprite.flip_h = not facing_right
