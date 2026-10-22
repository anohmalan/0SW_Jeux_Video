class_name PlayerJump
extends BaseState

@export var player : Player
@export var jump_speed : float = 300.0
var animated_sprite : AnimatedSprite2D

func enter():
	print("On entre dans jump")
	animated_sprite = player.get_animated_sprite()
	player.velocity.y = -jump_speed
	animated_sprite.play("jump")

func handle_inputs(input_event: InputEvent) -> void :
	pass

func update(delta: float) -> void:
	if not animated_sprite :
		animated_sprite = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if not animated_sprite : return

	if player.velocity.y >= 0:
		Transitioned.emit(self, "PlayerFall")
		return

	var dir : float = Input.get_axis("ui_left", "ui_right")
	player.velocity.x = dir * player.MAX_SPEED
	if dir != 0:
		player.facing_right = dir > 0

func exit() -> void:
	print("On sort de jump")
	pass
