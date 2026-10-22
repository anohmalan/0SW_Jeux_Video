extends GenericCharacter
class_name Player

@export var MAX_SPEED : float = 200.0
@export var ACCEL : float = 10.0
@export var facing_right : bool = true

func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	dir()
	animated_sprite.flip_h = not facing_right
	move_and_slide()

func dir() -> void:
	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false