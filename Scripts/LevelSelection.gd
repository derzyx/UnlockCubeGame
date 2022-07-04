extends Spatial

onready var tween = self.get_parent().get_node("Tween")
onready var cameraFocus = self.get_parent().get_node("CameraFocus")
onready var camera = self.get_parent().get_node("Camera")
onready var animator = self.get_parent().get_node("AnimationPlayer")
onready var chooseLvlBtn = self.get_parent().get_node("GUI/MainGUI/StartMenu/ChooseLevelBtn")
var currentRow
var currentCube
var lastLevelCube: KinematicBody
var cubeIsUp: bool

func _ready():
	prepareLevel()
	animator.play("LevelEnter")
	animator.seek(0.0, true)
	animator.stop(true)
	cubeIsUp = true
	chooseLvlBtn.disabled = false

func _process(delta):

	var left = Input.is_action_just_pressed("move_left")
	var forward = Input.is_action_just_pressed("move_forward")
	var right = Input.is_action_just_pressed("move_right")
	var back = Input.is_action_just_pressed("move_back")
	
	if !tween.is_active() and !cubeIsUp:
		if forward and (currentRow.get_parent().get_child(currentRow.get_index() + 1) != null):
			tween.interpolate_property(self, "translation:z", self.translation.z, self.translation.z + 8, .5)
			tween.start()
			
		if back and (currentRow.get_parent().get_child(currentRow.get_index() - 1) != null):
			tween.interpolate_property(self, "translation:z", self.translation.z, self.translation.z - 8, .5)
			tween.start()
			
		if left and (currentRow.get_child(currentCube.get_index() - 1) != null):
			tween.interpolate_property(currentRow, "translation:x", currentRow.translation.x, currentRow.translation.x + 5, .5)
			tween.start()
			
		if right and (currentRow.get_child(currentCube.get_index() + 1) != null):
			tween.interpolate_property(currentRow, "translation:x", currentRow.translation.x, currentRow.translation.x - 5, .5)
			tween.start()


func _on_CameraFocus_body_entered(body):
	currentCube = get_node(body.get_path())
	currentRow = get_node(currentCube.get_parent().get_path())
	
# Before leaving this level
func tweenCubeGoUp():
	tween.interpolate_property(currentCube, "translation:y", currentCube.translation.y, currentCube.translation.y + 20, .8, Tween.TRANS_CUBIC, Tween.EASE_OUT)	
	tween.interpolate_property(currentCube, "scale", currentCube.scale, Vector3.ONE, .6)	
	tween.start()

# After Entering
func tweenCubeGoDown():
	tween.interpolate_property(lastLevelCube, "translation:y", lastLevelCube.translation.y, 0, .8, Tween.EASE_IN)
	tween.interpolate_property(lastLevelCube, "scale", lastLevelCube.scale, Vector3(0.8, 0.8, 0.8), .6)
	tween.start()
	cubeIsUp = false
	chooseLvlBtn.disabled = true


# Before Entering
func prepareLevel():
	var lastLevel = $"/root/Settings".loadSetting("lastLevel", "lastLevel")
	var rowNumber = int(lastLevel[6])
	var cubeNumber = int(lastLevel[8])
	
	lastLevelCube = self.get_child(rowNumber - 1).get_child(cubeNumber - 1)
	lastLevelCube.translation.y = 20
	lastLevelCube.scale = Vector3.ONE
	
	self.translate(Vector3((cubeNumber - 1) * -5, 0, (rowNumber - 1) * 8))


func _on_chooseLevel_pressed():
	animator.play("LevelEnter")

func _on_play_pressed():
	$"/root/Settings".saveSetting("lastLevel", "lastLevel", currentCube.name)


func _on_SwipeDetector_swipedForward():
	if !tween.is_active() and !cubeIsUp:
		if (currentRow.get_parent().get_child(currentRow.get_index() - 1) != null):
			tween.interpolate_property(self, "translation:z", self.translation.z, self.translation.z - 8, .5)
			tween.start()


func _on_SwipeDetector_swipedBack():
	if !tween.is_active() and !cubeIsUp:
		if (currentRow.get_parent().get_child(currentRow.get_index() + 1) != null):
			tween.interpolate_property(self, "translation:z", self.translation.z, self.translation.z + 8, .5)
			tween.start()

func _on_SwipeDetector_swipedLeft():
	if !tween.is_active() and !cubeIsUp:
		if (currentRow.get_child(currentCube.get_index() + 1) != null):
			tween.interpolate_property(currentRow, "translation:x", currentRow.translation.x, currentRow.translation.x - 5, .5)
			tween.start()

func _on_SwipeDetector_swipedRight():
	if !tween.is_active() and !cubeIsUp:
		if (currentRow.get_child(currentCube.get_index() - 1) != null):
			tween.interpolate_property(currentRow, "translation:x", currentRow.translation.x, currentRow.translation.x + 5, .5)
			tween.start()
