extends KinematicBody

export(NodePath) var Cube
export(int) var Moves

signal hasMoved(remainingMoves)
signal gameOver()

onready var tween = get_node("Tween")
var moveVector
var rotationVector
var posX
var posZ
const MOVE_DISTANCE = 0.65
const BORDER_POS = 1
var rotateCube = false
var useSwipe = false

export(NodePath) var UpBtn

export(Array) var directions = [false, false, false, false]

func _ready():
	emit_signal("hasMoved", Moves)


func _physics_process(_delta):
	var left = Input.is_action_just_pressed("move_left")
	var forward = Input.is_action_just_pressed("move_forward")
	var right = Input.is_action_just_pressed("move_right")
	var back = Input.is_action_just_pressed("move_back")
	
	if !tween.is_active():
		rotateCube = false
		################################################################################
		if left and directions[0]:
			if self.transform.origin.x - MOVE_DISTANCE < -BORDER_POS:
				posX = -self.transform.origin.x
				rotateCube = true
				rotationVector = Vector3(0,0,-1)
			else:
				posX = self.transform.origin.x - MOVE_DISTANCE
			moveKey(posX, self.transform.origin.z, rotateCube, rotationVector)
			Moves -= 1
			emit_signal("hasMoved", Moves)
			if(Moves == 0):
				emit_signal("gameOver")
				set_physics_process(false)
		#################################################################################	
		elif forward and directions[1]:
			if self.transform.origin.z - MOVE_DISTANCE < -BORDER_POS:
				posZ = -self.transform.origin.z
				rotateCube = true
				rotationVector = Vector3(1,0,0)
			else:
				posZ = self.transform.origin.z - MOVE_DISTANCE	
			moveKey(self.transform.origin.x, posZ, rotateCube, rotationVector)
			Moves -= 1
			emit_signal("hasMoved", Moves)
			if(Moves == 0):
				emit_signal("gameOver")
				set_physics_process(false)
		##################################################################################
		elif right and directions[2]:	
			if self.transform.origin.x + MOVE_DISTANCE > BORDER_POS:
				posX = -self.transform.origin.x
				rotateCube = true
				rotationVector = Vector3(0,0,1)
			else:
				posX = self.transform.origin.x + MOVE_DISTANCE
			moveKey(posX, self.transform.origin.z, rotateCube, rotationVector)
			Moves -= 1
			emit_signal("hasMoved", Moves)
			if(Moves == 0):
				emit_signal("gameOver")
				set_physics_process(false)
		##################################################################################	
		elif back and directions[3]:
			if self.transform.origin.z + MOVE_DISTANCE > BORDER_POS:
				posZ = -self.transform.origin.z
				rotateCube = true
				rotationVector = Vector3(-1,0,0)
			else:
				posZ = self.transform.origin.z + MOVE_DISTANCE
			moveKey(self.transform.origin.x, posZ, rotateCube, rotationVector)
			Moves -= 1
			emit_signal("hasMoved", Moves)
			if(Moves == 0):
				emit_signal("gameOver")
				set_physics_process(false)
		
					
func moveKey(distX, distZ, rotateCubeBool, rotVector):
	moveVector = Vector3(distX, self.translation.y, distZ)
	
	# ROTATING CUBE
	if rotateCubeBool:
		tween.interpolate_property(get_node(Cube), 
			"transform:basis", 
			get_node(Cube).transform.basis, 
			get_node(Cube).transform.basis.rotated(rotVector, PI/2), 
			.150)
			
	# MOVING KEY
	tween.interpolate_property(self, "translation", self.translation, moveVector, .150)
	tween.start()
	rotateCube = false
	
func toggleAreas(state):
	if state:
		self.get_node("Left_Area").collision_layer = 1
		self.get_node("Left_Area").collision_mask = 2
		
		self.get_node("Forward_Area").collision_layer = 1
		self.get_node("Forward_Area").collision_mask = 2
		
		self.get_node("Right_Area").collision_layer = 1
		self.get_node("Right_Area").collision_mask = 2
		
		self.get_node("Back_Area").collision_layer = 1
		self.get_node("Back_Area").collision_mask = 2
	else:
		self.get_node("Left_Area").collision_layer = 0
		self.get_node("Left_Area").collision_mask = 0
		
		self.get_node("Forward_Area").collision_layer = 0
		self.get_node("Forward_Area").collision_mask = 0
		
		self.get_node("Right_Area").collision_layer = 0
		self.get_node("Right_Area").collision_mask = 0
		
		self.get_node("Back_Area").collision_layer = 0
		self.get_node("Back_Area").collision_mask = 0

func keyGoUp():
	tween.interpolate_property(self, "translation", self.translation, Vector3(self.translation.x, 5.5, self.translation.z), .5)
	tween.start()


func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	get_node(Cube).transform = get_node(Cube).transform.orthonormalized()


func _on_Left_Area_body_entered(body):
	directions[0] = true
		
func _on_Left_Area_body_exited(_body):
	directions[0] = false



func _on_Forward_Area_body_entered(body):
	directions[1] = true
		
func _on_Forward_Area_body_exited(_body):
	directions[1] = false



func _on_Right_Area_body_entered(body):
	directions[2] = true
		
func _on_Right_Area_body_exited(_body):
	directions[2] = false



func _on_Back_Area_body_entered(body):
	directions[3] = true

func _on_Back_Area_body_exited(_body):
	directions[3] = false


func _on_Tween_tween_started(_object, _key):
	toggleAreas(false)


func _on_Tween_tween_completed(_object, _key):
	toggleAreas(true)


func _on_ForwardBtn_pressed():
	if !tween.is_active():
		rotateCube = false
		if directions[1]:
			if self.transform.origin.z - MOVE_DISTANCE < -BORDER_POS:
				posZ = -self.transform.origin.z
				rotateCube = true
				rotationVector = Vector3(1,0,0)
			else:
				posZ = self.transform.origin.z - MOVE_DISTANCE	
			moveKey(self.transform.origin.x, posZ, rotateCube, rotationVector)
		Moves -= 1
		emit_signal("hasMoved", Moves)
		if(Moves == 0):
			emit_signal("gameOver")
			set_physics_process(false)


func _on_LeftBtn_pressed():
	if !tween.is_active():
		rotateCube = false
		if directions[0]:
			if self.transform.origin.x - MOVE_DISTANCE < -BORDER_POS:
				posX = -self.transform.origin.x
				rotateCube = true
				rotationVector = Vector3(0,0,-1)
			else:
				posX = self.transform.origin.x - MOVE_DISTANCE
			moveKey(posX, self.transform.origin.z, rotateCube, rotationVector)	
		Moves -= 1	
		emit_signal("hasMoved", Moves)
		if(Moves == 0):
			emit_signal("gameOver")
			set_physics_process(false)

func _on_BackBtn_pressed():
	if !tween.is_active():
		rotateCube = false
		if directions[3]:
			if self.transform.origin.z + MOVE_DISTANCE > BORDER_POS:
				posZ = -self.transform.origin.z
				rotateCube = true
				rotationVector = Vector3(-1,0,0)
			else:
				posZ = self.transform.origin.z + MOVE_DISTANCE
			moveKey(self.transform.origin.x, posZ, rotateCube, rotationVector)
		Moves -= 1
		emit_signal("hasMoved", Moves)
		if(Moves == 0):
			emit_signal("gameOver")
			set_physics_process(false)

func _on_RightBtn_pressed():
	if !tween.is_active():
		rotateCube = false
		if directions[2]:	
			if self.transform.origin.x + MOVE_DISTANCE > BORDER_POS:
				posX = -self.transform.origin.x
				rotateCube = true
				rotationVector = Vector3(0,0,1)
			else:
				posX = self.transform.origin.x + MOVE_DISTANCE
			moveKey(posX, self.transform.origin.z, rotateCube, rotationVector)
		Moves -= 1
		emit_signal("hasMoved", Moves)
		if(Moves == 0):
			emit_signal("gameOver")
			set_physics_process(false)


func _on_Finish_body_entered(body):
	if(body.name == "DetectFinish"):
		set_physics_process(false)
