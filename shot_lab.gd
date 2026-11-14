extends Node3D

# Motion lab only. Replace procedural geometry after the release feels right.
const PEAK := 0.64
const GRAVITY := 9.8
var clock := 0.0
var state := "ready"
var held := false
var start_y := 0.0
var pointer := -2
var flight := 0.0
var velocity := Vector3.ZERO
var previous_ball := Vector3.ZERO
var counted := false
var made := 0
var attempts := 0
var active_time := 0.0
var guide := true
var rig: Node3D
var ball: MeshInstance3D
var arms: Array[MeshInstance3D] = []
var legs: Array[MeshInstance3D] = []
var shoes: Array[MeshInstance3D] = []
var hands := Vector3.ZERO
var info: Label
var score: Label
var cue: ProgressBar
var hint: Label
var hoop := Vector3(3.15, 2.45, 0)
var skin := Color("a87249")
var shirt := Color("258e8b")

func material(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.95
	return m

func box(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	n.mesh = mesh
	n.material_override = material(color)
	parent.add_child(n)
	n.position = pos
	return n

func sphere(parent: Node3D, pos: Vector3, radius: float, color: Color) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2
	mesh.radial_segments = 12
	mesh.rings = 6
	n.mesh = mesh
	n.material_override = material(color)
	parent.add_child(n)
	n.position = pos
	return n

func segment(n: MeshInstance3D, a: Vector3, b: Vector3, width: float) -> void:
	n.position = (a + b) * 0.5
	n.scale = Vector3(width, a.distance_to(b), width)
	var axis := (b-a).normalized()
	var side := Vector3.FORWARD.cross(axis).normalized()
	n.basis = Basis(side, axis, side.cross(axis)).scaled(n.scale)

func label_at(parent: Node, text_value: String, y: float, font_size: int) -> Label:
	var l := Label.new()
	l.text = text_value
	l.position = Vector2(24, y)
	l.size = Vector2(492, 55)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", font_size)
	parent.add_child(l)
	return l

func _ready() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("202e40")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color.WHITE
	e.ambient_light_energy = 0.65
	env.environment = e
	add_child(env)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45,-30,0)
	light.light_energy = 1.1
	add_child(light)
	box(self, Vector3(1,-0.08,0), Vector3(11,0.16,7), Color("ae794b"))
	box(self, Vector3(1,2,-2.7), Vector3(11,4,0.2), Color("d3c9ad"))
	box(self, Vector3(1,0.65,-2.5), Vector3(11,1.3,0.15), Color("266b70"))
	for x in range(-4,7):
		box(self,Vector3(x,0.008,0),Vector3(0.018,0.012,7),Color("8d613d"))
	box(self,Vector3(1.8,0.02,0),Vector3(0.035,0.02,4),Color("f6e4be"))
	box(self,Vector3(3.85,1.5,0),Vector3(0.12,3,0.12),Color("3b444c"))
	box(self,Vector3(3.65,2.85,0),Vector3(0.1,1.05,1.5),Color("e6e1d3"))
	var rim := MeshInstance3D.new()
	var torus := TorusMesh.new()
	torus.inner_radius = 0.225
	torus.outer_radius = 0.265
	torus.rings = 20
	torus.ring_segments = 8
	rim.mesh = torus
	rim.material_override = material(Color("e86c30"))
	add_child(rim)
	rim.position = hoop
	for i in range(10):
		var a := float(i) / 10 * TAU
		var net := box(self, Vector3.ZERO, Vector3.ONE, Color("efe6cc"))
		segment(net,hoop+Vector3(cos(a)*0.23,-0.02,sin(a)*0.23),hoop+Vector3(cos(a+0.3)*0.15,-0.35,sin(a+0.3)*0.15),0.014)
	rig = Node3D.new()
	add_child(rig)
	box(rig,Vector3(0,0.99,0),Vector3(0.32,0.43,0.4),shirt)
	sphere(rig,Vector3(0,1.43,0),0.19,skin)
	box(rig,Vector3(-0.03,1.57,0),Vector3(0.32,0.14,0.36),Color("302820"))
	for z in [-0.13,0.13]:
		box(rig,Vector3(0,0.71,z),Vector3(0.29,0.27,0.22),Color("323a48"))
		for j in range(2):
			legs.append(box(rig,Vector3.ZERO,Vector3.ONE,skin))
		shoes.append(box(rig,Vector3(0.08,0.07,z),Vector3(0.38,0.14,0.22),Color("e4e4d9")))
		for j in range(2):
			arms.append(box(rig,Vector3.ZERO,Vector3.ONE,skin))
	ball = sphere(self,Vector3.ZERO,0.14,Color("db7029"))
	# Dark ball seam bands make rotation readable.
	for axis in [Vector3.ZERO,Vector3(PI/2,0,0),Vector3(0,0,PI/2)]:
		var seam := MeshInstance3D.new()
		var t := TorusMesh.new()
		t.inner_radius = 0.137
		t.outer_radius = 0.142
		t.rings = 16
		t.ring_segments = 4
		seam.mesh = t
		seam.material_override = material(Color("3f3226"))
		ball.add_child(seam)
		seam.rotation = axis
	var cam := Camera3D.new()
	add_child(cam)
	cam.position = Vector3(5.8,3.5,8.8)
	cam.look_at(Vector3(1.25,1.35,0))
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 5.9
	cam.current = true
	var canvas := CanvasLayer.new()
	add_child(canvas)
	label_at(canvas,"SHOT LAB / YEAR ONE",25,22)
	score = label_at(canvas,"0 / 0",62,28)
	info = label_at(canvas,"Find your release",710,28)
	cue = ProgressBar.new()
	cue.position = Vector2(80,785)
	cue.size = Vector2(380,18)
	cue.max_value = 1.0
	cue.show_percentage = false
	canvas.add_child(cue)
	hint = label_at(canvas,"Hold • drag down to start • release at the peak",825,17)
	var toggle := Button.new()
	toggle.text = "Timing guide: ON"
	toggle.position = Vector2(165,895)
	toggle.size = Vector2(210,42)
	canvas.add_child(toggle)
	toggle.pressed.connect(func():
		guide = not guide
		cue.visible = guide
		toggle.text = "Timing guide: ON" if guide else "Timing guide: OFF")
	pose(0.0)

func pose(t: float) -> void:
	var lift := smoothstep(0.08, PEAK, t)
	var follow := smoothstep(PEAK,0.9,t)
	var recover := smoothstep(1.15,1.65,t)
	var crouch := sin(clampf(t/0.38,0,1)*PI)*0.14
	var jump := maxf(0,sin(clampf((t-0.35)/0.65,0,1)*PI))*0.24
	rig.position.y = jump-crouch
	var hand := Vector3(lerpf(0.35,0.25,lift)+follow*0.18,lerpf(1.02,1.8,lift),0)
	hand = hand.lerp(Vector3(0.35,1.02,0),recover)
	for i in range(2):
		var z := -0.24 if i == 0 else 0.24
		var shoulder := Vector3(0,1.15,z)
		var elbow := Vector3(lerpf(0.29,0.43,lift),lerpf(0.88,1.43,lift),z)
		elbow = elbow.lerp(Vector3(0.29,0.88,z),recover)
		segment(arms[i*2],shoulder,elbow,0.105)
		segment(arms[i*2+1],elbow,hand+Vector3(0,0,z*0.32),0.085)
		var knee := Vector3(crouch*1.2,0.39,z*0.54)
		segment(legs[i*2],Vector3(0,0.7,z*0.54),knee,0.13)
		segment(legs[i*2+1],knee,Vector3(0,0.13-jump+crouch,z*0.54),0.10)
	hands = hand+rig.position+Vector3(0.05,0.08,0)
	if state != "flight":
		ball.position = hands

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and pointer == -2:
			press(event.position.y,event.index)
		elif not event.pressed and pointer == event.index:
			release_shot()
	elif event is InputEventScreenDrag and pointer == event.index:
		drag(event.position.y)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			press(event.position.y,-1)
		elif pointer == -1:
			release_shot()
	elif event is InputEventMouseMotion and pointer == -1:
		drag(event.position.y)

func press(y: float, id: int) -> void:
	if state != "ready" or y < 620 or y > 880:
		return
	held = true
	pointer = id
	start_y = y

func drag(y: float) -> void:
	if held and state == "ready" and y-start_y > 18:
		state = "shooting"
		clock = 0

func release_shot() -> void:
	held = false
	pointer = -2
	if state != "shooting":
		return
	var error := clock-PEAK
	var target := hoop + Vector3(error*1.7,0,0)
	var duration := 0.90
	velocity = (target-ball.position)/duration + Vector3(0,GRAVITY*duration*0.5,0)
	state = "flight"
	flight = 0
	counted = false
	attempts += 1
	info.text = "ON TIME" if absf(error)<0.075 else ("EARLY" if error<0 else "LATE")

func _physics_process(delta: float) -> void:
	active_time += delta if state != "ready" else 0.0
	if state == "shooting" or state == "flight":
		clock += delta
		pose(clock)
		cue.value = clampf(clock/PEAK,0,1)
		cue.modulate = Color("63edaa") if absf(clock-PEAK)<0.075 else Color.WHITE
	if state == "shooting" and clock > 1.05:
		release_shot()
	if state == "flight":
		flight += delta
		previous_ball = ball.position
		velocity.y -= GRAVITY*delta
		ball.position += velocity*delta
		ball.rotate_z(-delta*4)
		if not counted and previous_ball.y >= hoop.y and ball.position.y < hoop.y and velocity.y < 0:
			counted = true
			var fraction := (previous_ball.y-hoop.y)/(previous_ball.y-ball.position.y)
			var crossing := previous_ball.lerp(ball.position,fraction)
			if Vector2(crossing.x-hoop.x,crossing.z-hoop.z).length() < 0.11:
				made += 1
				info.text += "  /  SWISH"
			else:
				info.text += "  /  MISS"
			score.text = "%d / %d" % [made,attempts]
		if ball.position.y < 0.14 and velocity.y < 0:
			ball.position.y = 0.14
			velocity.y *= -0.55
			velocity.x *= 0.75
		if flight > 2.3:
			state = "ready"
			clock = 0
			pose(0)
			cue.value = 0
