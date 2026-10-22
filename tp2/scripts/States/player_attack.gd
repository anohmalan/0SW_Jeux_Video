class_name PlayerAttack
extends BaseState

@export var player : Player
@export var attack_speed : float = 50.0
var animated_sprite : AnimatedSprite2D

func enter():
	print("On entre dans attack")
	animated_sprite = player.get_animated_sprite()
	animated_sprite.play("attack")
	player.velocity.x = attack_speed if player.facing_right else -attack_speed


func handle_inputs(input_event: InputEvent) -> void :
	pass

func update(delta: float) -> void:
	if not animated_sprite :
		animated_sprite = player.get_animated_sprite()

func physics_update(delta: float) -> void:
	if not animated_sprite : return

	if not animated_sprite.is_playing():
		if not player.is_on_floor():
			Transitioned.emit(self, "PlayerFall")
		elif Input.get_axis("ui_left", "ui_right") != 0:
			Transitioned.emit(self, "PlayerRun")
		else:
			Transitioned.emit(self, "PlayerIdle")

func exit() -> void:
	print("On sort de attack")
	player.velocity.x = 0
	pass
