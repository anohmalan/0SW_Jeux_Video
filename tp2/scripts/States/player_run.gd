class_name PlayerRun
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D

@export var move_speed := 50.0

var dir : float = 0.0

func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	dir = Input.get_axis("ui_left", "ui_right")

func update(delta : float) -> void:
	if not animated_sprite :
		animated_sprite = player.get_animated_sprite()
	
	print(animated_sprite)

	if dir != 0:
		player.velocity.x =  lerp(player.velocity.x, player.MAX_SPEED * dir, (player.ACCEL * 1.0) / player.MAX_SPEED)
	else :
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)

	if (player.velocity.x == 0) :
		Transitioned.emit(self, "PlayerIdle")

	player.facing_right = dir > 0

func physics_update(delta: float) -> void:
	if (player.velocity.x != 0):
		player.facing_right = player.velocity.x > 0

	if not animated_sprite : return

	animated_sprite.play("run")

func enter() -> void:
	pass

func exit() -> void:
	pass
