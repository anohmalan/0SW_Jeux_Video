extends Node2D

@onready var camera : Camera2D = $Player/Camera2D
@onready var level_tiles : TileMapLayer = $Level1/TileMapLayer

func _ready() -> void:
	var used_rect := level_tiles.get_used_rect()
	var tile_size := level_tiles.tile_set.tile_size
	var level_start := level_tiles.to_global(Vector2(used_rect.position * tile_size))
	var level_end := level_tiles.to_global(Vector2(used_rect.end * tile_size))
	var view_size := get_viewport_rect().size / camera.zoom

	# Leave room above the highest platform for the player's jump.
	var bounds := Rect2(level_start, level_end - level_start)
	bounds = bounds.grow_individual(0.0, view_size.y * 0.5, 0.0, 32.0)
	var extra_size := (view_size - bounds.size).max(Vector2.ZERO)
	bounds.position -= extra_size * 0.5
	bounds.size += extra_size

	camera.limit_left = floori(bounds.position.x)
	camera.limit_top = floori(bounds.position.y)
	camera.limit_right = ceili(bounds.end.x)
	camera.limit_bottom = ceili(bounds.end.y)
	camera.reset_smoothing()
