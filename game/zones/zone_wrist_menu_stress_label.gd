extends Label

func _process(delta: float) -> void:
	text = str(GameState.brain_strain)
