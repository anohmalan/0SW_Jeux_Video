extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("T'es mort")
	$Timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
