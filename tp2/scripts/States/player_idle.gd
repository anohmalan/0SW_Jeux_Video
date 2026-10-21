class_name PlayerIdle
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite = player.get_animated_sprite()


func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	var dir : float = Input.get_axis("ui_left", "ui_right")

	if (dir != 0):
		Transitioned.emit(self, "PlayerRun")

func update(delta: float) -> void:
	if not animated_sprite :
		animated_sprite = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if not animated_sprite : return

	animated_sprite.play("idle")

func exit() -> void:
	pass