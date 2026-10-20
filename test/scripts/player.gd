class_name Player
extends CharacterBody2D

enum State { STATE_JUMPING, STATE_IDLE, STATE_RUNNING, STATE_FALLING, STATE_ATTACK, STATE_DEATH }

var current_state: State = State.STATE_IDLE

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ATTACK_BRAKE = 1200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction := 0.0
var is_dead := false

func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if is_dead:
		_play_if_needed("death")
		return

	direction = Input.get_axis("ui_left", "ui_right")

	if not is_on_floor():
		velocity += get_gravity() * delta

	if _is_jump_pressed() and is_on_floor() and current_state != State.STATE_ATTACK:
		velocity.y = JUMP_VELOCITY
		current_state = State.STATE_JUMPING

	if Input.is_action_just_pressed("attack") and is_on_floor() and current_state != State.STATE_ATTACK:
		current_state = State.STATE_ATTACK
		_play_if_needed("attack")

	match current_state:
		State.STATE_ATTACK:
			attack()
		State.STATE_JUMPING:
			jump()
		State.STATE_FALLING:
			fall()
		State.STATE_RUNNING:
			run()
		_:
			idle()

	animated_sprite.flip_h = direction < 0
	move_and_slide()
	_update_air_state()

func _is_jump_pressed() -> bool:
	if InputMap.has_action("ui_jump") and Input.is_action_just_pressed("ui_jump"):
		return true
	return Input.is_action_just_pressed("ui_accept")

func _on_animation_finished() -> void:
	if is_dead:
		return

	if animated_sprite.animation == "attack" and current_state == State.STATE_ATTACK:
		current_state = State.STATE_RUNNING if abs(direction) > 0.0 else State.STATE_IDLE

func _play_if_needed(animation_name: String) -> void:
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func _update_air_state() -> void:
	if current_state == State.STATE_ATTACK:
		return

	if not is_on_floor():
		if velocity.y < 0.0:
			current_state = State.STATE_JUMPING
			_play_if_needed("jump")
		else:
			current_state = State.STATE_FALLING
			_play_if_needed("fall")
	elif current_state == State.STATE_JUMPING or current_state == State.STATE_FALLING:
		current_state = State.STATE_RUNNING if abs(direction) > 0.0 else State.STATE_IDLE

func jump() -> void:
	velocity.x = direction * SPEED
	_play_if_needed("jump")

func fall() -> void:
	velocity.x = direction * SPEED
	_play_if_needed("fall")

func idle() -> void:
	velocity.x = move_toward(velocity.x, 0.0, SPEED)
	if abs(direction) > 0.0:
		current_state = State.STATE_RUNNING
		_play_if_needed("run")
	else:
		_play_if_needed("idle")

func run() -> void:
	if abs(direction) <= 0.0:
		current_state = State.STATE_IDLE
		_play_if_needed("idle")
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		return

	velocity.x = direction * SPEED
	_play_if_needed("run")

func attack() -> void:
	velocity.x = move_toward(velocity.x, 0.0, ATTACK_BRAKE)
	_play_if_needed("attack")

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	_play_if_needed("death")
