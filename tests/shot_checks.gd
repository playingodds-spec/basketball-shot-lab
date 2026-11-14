extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var lab = load("res://main.tscn").instantiate()
	root.add_child(lab)
	lab.set_physics_process(false)
	await process_frame
	for timing in [0.30,0.64,0.95]:
		lab.state = "ready"
		lab.pose(0.0)
		lab.press(700,-1)
		lab.drag(730)
		assert(lab.state == "shooting", "Drag must trigger animation")
		lab.clock = timing
		lab.pose(timing)
		assert(lab.ball.position.distance_to(lab.hands)<0.001,"Ball must stay in hands before release")
		var before: int = lab.made
		lab.release_shot()
		assert(lab.state == "flight", "Release must launch ball")
		for frame in range(360):
			lab._physics_process(1.0/120.0)
		assert(lab.state == "ready", "Must reset after shot")
		if timing == 0.64:
			assert(lab.made == before+1,"On-time shot must score")
		else:
			assert(lab.made == before,"Large release errors must miss")
		print("PASS release ",timing," / ",lab.info.text)
	assert(lab.attempts == 3)
	quit()
