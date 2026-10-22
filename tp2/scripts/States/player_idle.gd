class_name PlayerIdle
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D

func enter():
	print("On entre dans idle")
	animated_sprite = player.get_animated_sprite()


func handle_inputs(input_event: InputEvent) -> void :
	if not player.is_on_floor():
		return
	if input_event.is_action_pressed("attack"):
		Transitioned.emit(self, "PlayerAttack")
	elif input_event.is_action_pressed("ui_accept"):
		Transitioned.emit(self, "PlayerJump")

func update(delta: float) -> void:
	if not animated_sprite :
		animated_sprite = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		return

	if not animated_sprite : return

	if Input.get_axis("ui_left", "ui_right") != 0:
		Transitioned.emit(self, "PlayerRun")
		return

	player.velocity.x = 0
	animated_sprite.play("idle")

func exit() -> void:
	print("On sort de idle")
	pass