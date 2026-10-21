extends GenericCharacter
class_name Player

func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	# animated_sprite.play("idle")


func _physics_process(delta: float) -> void:
	move_and_slide()
