extends Control

const optionsNodeName = "Opcje"
const mainGUINodeName = "MainGUI"
const pauseNodeName = "Pauza"
const volumeIconNode = "dzwiekIcon"
const movementIconNode = "sterowanieIcon"
const startMenuNode = "StartMenu"
const playLevelNode = "PlayLevelBtn"
const endLevelNode = "KoniecPoziomu"

const crossPosRightNode = "CrossPosRight"
const crossPosLeftNode = "CrossPosLeft"
const crossCtrlLeftNode = "CrossControlLeft"
const crossCtrlRightNode = "CrossControlRight"

var enterAnimationLength:float
var time = 0
var timerNode

func _ready():
	self.get_node(mainGUINodeName).show()
	self.get_node(optionsNodeName).hide()
	if(self.has_node(pauseNodeName)):
		self.get_node(pauseNodeName).hide()
	if(self.has_node(endLevelNode)):
		self.get_node(endLevelNode).hide()	
	
	if($"/root/Settings".loadSetting("options", "movement") == "swipe"):
		$"/root/Settings".saveSetting("options", "movement", "swipe")
		self.find_node(movementIconNode).texture = load("res://Textures/swipeIcon.png")
		if(self.get_parent().name.begins_with("Level")):
			self.find_node(crossCtrlRightNode).hide()
			self.find_node(crossPosRightNode).hide()
			self.find_node(crossCtrlLeftNode).hide()
			self.find_node(crossPosLeftNode).hide()
#
#
	elif($"/root/Settings".loadSetting("options", "movement") == "arrows"):
		$"/root/Settings".saveSetting("options", "movement", "arrows")
		self.find_node(movementIconNode).texture = load("res://Textures/arrowsIcon.png")
		if(self.get_parent().name.begins_with("Level")):
			_on_CrossPosRight_pressed()
	set_process(false)
	
	if(self.get_parent().name.begins_with("Level")):	
		enterAnimationLength = self.get_parent().get_node("AnimationPlayer").get_current_animation_length()
		time = enterAnimationLength * -1
		timerNode = self.find_node("Timer")
		#set_process(true)
	else:
		pass
		#set_process(false)
	
func _process(delta):
	time += delta
	
	#var msec = fmod(time, 1)*1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	#var time_passed = "%02d:%02d:%03d" % [mins,secs,msec]
	var time_passed = "%02d:%02d" % [mins,secs]
	#timerNode.text = time_passed

func resumeGame():
	set_process(true)
	
func pauseGame():
	set_process(false)

func mainGUIVisibility(visible:bool):
	if(visible):
		self.get_node(mainGUINodeName).show()
	else:
		self.get_node(mainGUINodeName).hide()

func optionsVisibility(visible:bool):
	print(visible)
	if(visible):
		self.get_node(optionsNodeName).show()
	else:
		self.get_node(optionsNodeName).hide()
	
func pauseVisibility(visible:bool):
	if(self.has_node(pauseNodeName)):
		if(visible):
			self.get_node(pauseNodeName).show()
		else:
			self.get_node(pauseNodeName).hide()
			
func startMenuVisibility(visible:bool):
	if(self.find_node(startMenuNode)):
		if(visible):
			self.find_node(startMenuNode).show()
		else:
			self.find_node(startMenuNode).hide()

func playLevelVisibility(visible:bool):
	if(self.find_node(playLevelNode)):
		if(visible):
			self.find_node(playLevelNode).show()
		else:
			self.find_node(playLevelNode).hide()
			
func endLevelVisibility(visible:bool, _success):
	if(self.has_node(endLevelNode)):
		if(visible):
			if(_success):
				self.get_node(endLevelNode).get_node("EndMessage/Label").text = "Poziom ukończony"
				self.get_node(endLevelNode).find_node("nastPoziom").disabled = false
			else:
				self.get_node(endLevelNode).get_node("EndMessage/Label").text = "Zabrakło ruchów"
				self.get_node(endLevelNode).find_node("nastPoziom").disabled = true
			self.get_node(endLevelNode).show()
		else:
			self.get_node(endLevelNode).hide()	

func changeVolumeOptions():
	if($"/root/Settings".loadSetting("options", "volume") == "on"):
		#print(load("res://Textures/volumeOffIcon.png"))
		self.find_node(volumeIconNode).texture = load("res://Textures/volumeOffIcon.png")
		$"/root/Settings".saveSetting("options", "volume", "off")
	else:
		self.find_node(volumeIconNode).texture = load("res://Textures/volumeOnIcon.png")
		$"/root/Settings".saveSetting("options", "volume", "on")


func changeSteeringOptions():
	if($"/root/Settings".loadSetting("options", "movement") == "swipe"):
		self.find_node(movementIconNode).texture = load("res://Textures/arrowsIcon.png")
		$"/root/Settings".saveSetting("options", "movement", "arrows")
		if(self.get_parent().name.begins_with("Level")):
			_on_CrossPosRight_pressed()

	elif($"/root/Settings".loadSetting("options", "movement") == "arrows"):
		self.find_node(movementIconNode).texture = load("res://Textures/swipeIcon.png")
		$"/root/Settings".saveSetting("options", "movement", "swipe")
		if(self.get_parent().name.begins_with("Level")):
			self.find_node(crossCtrlRightNode).hide()
			self.find_node(crossPosRightNode).hide()
			self.find_node(crossCtrlLeftNode).hide()
			self.find_node(crossPosLeftNode).hide()


func _on_CrossPosRight_pressed():
	self.find_node(crossCtrlRightNode).hide()
	self.find_node(crossPosRightNode).hide()
	self.find_node(crossCtrlLeftNode).show()
	self.find_node(crossPosLeftNode).show()

func _on_CrossPosLeft_pressed():
	self.find_node(crossCtrlLeftNode).hide()
	self.find_node(crossPosLeftNode).hide()
	self.find_node(crossCtrlRightNode).show()
	self.find_node(crossPosRightNode).show()


func _on_Finish_body_entered(body):
	print(body)
	if(body.name == "DetectFinish"):
		mainGUIVisibility(false)
		endLevelVisibility(true, true)


func _on_Key_KB_hasMoved(remainingMoves):
	self.get_node("Timer").text = remainingMoves as String


func _on_Key_KB_gameOver():
	mainGUIVisibility(false)
	endLevelVisibility(true, false)
