class_name PlayerRun
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D

var BRAKE_SPEED : float = 190

func enter() -> void:
	print("On entre dans run")
	animated_sprite = player.get_animated_sprite()
	animated_sprite.play("run")

func handle_inputs(input_event: InputEvent) -> void :
	if not player.is_on_floor():
		return
	if input_event.is_action_pressed("attack"):
		Transitioned.emit(self, "PlayerAttack")
	elif input_event.is_action_pressed("ui_accept"):
		Transitioned.emit(self, "PlayerJump")

func update(delta : float) -> void:
	pass

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		return

	var dir : float = Input.get_axis("ui_left", "ui_right")
	if dir != 0:
		var weight : float = 1.0 - pow(1.0 - clampf(player.ACCEL / player.MAX_SPEED, 0.0, 1.0), delta * 60.0)
		player.velocity.x = lerpf(player.velocity.x, player.MAX_SPEED * dir, weight)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, BRAKE_SPEED * delta * 60.0)

	if is_zero_approx(player.velocity.x) and dir == 0:
		player.velocity.x = 0
		Transitioned.emit(self, "PlayerIdle")
		return

	if (player.velocity.x != 0):
		player.facing_right = player.velocity.x > 0

	if not animated_sprite : return

	animated_sprite.play("run")

func exit() -> void:
	print("Dans exit run")
	animated_sprite.stop()
	pass
