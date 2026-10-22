class_name PlayerFall
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D

func enter() -> void:
	print("On entre dans fall")
	animated_sprite = player.get_animated_sprite()
	animated_sprite.play("fall")

func handle_inputs(input_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if Input.get_axis("ui_left", "ui_right") != 0:
			Transitioned.emit(self, "PlayerRun")
		else:
			Transitioned.emit(self, "PlayerIdle")
		return

	var dir : float = Input.get_axis("ui_left", "ui_right")
	player.velocity.x = dir * player.MAX_SPEED
	if dir != 0:
		player.facing_right = dir > 0

func exit() -> void:
	print("On sort de fall")
	pass
