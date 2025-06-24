extends PersistentZone

func _ready() -> void:
	# call the base
	super()
	
	$AnalysisArea.analysis_end.connect(_on_analysis_end)

func _on_analysis_end(count):
	print(count)
