extends Node

onready var rootSceneChange = get_tree().get_root().get_child(1)

var resource_queue = preload("res://Scripts/resource_queue.gd").new()
onready var mainMenu = preload("res://Scenes/MainMenu.tscn")
var currentLvl

var animatorInCurrentLevel #Instance of Animator in current level
var animatorInNextLevel

var resourceLoaded: bool

var nextLevelResource
var nextLevelInstance
var nextLevelName: String
var nextLevelPath: String

func _ready():
	currentLvl = mainMenu.instance()
	
#	while(rootSceneChange.get_child_count() > 0):
#		rootSceneChange.remove_child(rootSceneChange.get_child(0))
	
	rootSceneChange.add_child(currentLvl)
	
	currentLvl.connect("level_changed", self, "handle_level_change")
	resource_queue.start()
	set_process(false)
	
func handle_level_change(currentLevelName):
	
	# temporary replacement for "for... in..." below
	if currentLevelName == "MainMenu":
		nextLevelName = "Level_1_1"
	else:
		nextLevelName = "MainMenu"
	
#	for section in $"/root/Settings".settings.keys():
#		if section == "levelsNames":
#			for key in $"/root/Settings".settings[section]:
#				if $"/root/Settings".settings[section][key] == currentLevelName:
#					nextLevelName = $"/root/Settings".settings[section][String(int(key) + 1)]
	
	nextLevelPath = "res://Scenes/" + nextLevelName + ".tscn"
	resource_queue.queue_resource(nextLevelPath, true)
	animatorInCurrentLevel = currentLvl.get_node("AnimationPlayer")
	
	if currentLevelName == "MainMenu":
		if !($"MainMenu/All cubes".cubeIsUp):
			animatorInCurrentLevel.play("LevelLeave")
	else:
		animatorInCurrentLevel.play("LevelLeave")
		
	set_process(true)
	
#func _process(delta):
#	if !animatorInCurrentLevel.is_playing():
#		var nextLevelInstance = load(nextLevelPath).instance()
#		nextLevelInstance.connect("level_changed", self, "handle_level_change")
#		rootSceneChange.add_child(nextLevelInstance)
#		rootSceneChange.remove_child(currentLvl)
#
#		animatorInNextLevel = nextLevelInstance.get_node("AnimationPlayer") 
#		animatorInNextLevel.play("LevelEnter")
#		animatorInNextLevel.seek(0.0, true)
#
#		print(self.get_children())
#		currentLvl = nextLevelInstance
#		set_process(false)
		
func _process(delta):
	if resource_queue.is_ready(nextLevelPath) and animatorInCurrentLevel.current_animation == "":
		# Get loaded scene
		nextLevelResource = resource_queue.get_resource(nextLevelPath) 
		# Get instance of that scene
		nextLevelInstance = nextLevelResource.instance() 
		# Add this instance as a child to "SceneChange" node
		add_child(nextLevelInstance)
		# Connect signal from "Level.gd" script to newly added scene
		nextLevelInstance.connect("level_changed", self, "handle_level_change") 
		# Set current animator to next level's animator
		animatorInNextLevel = nextLevelInstance.get_node("AnimationPlayer") 

		animatorInNextLevel.play("LevelEnter")
#		if(animatorInNextLevel.is_playing()):
#			print(animatorInNextLevel.current_animation)
		#animatorInNextLevel.seek(0.0, true)

		# Remove current scene
		currentLvl.queue_free() 
		# Instance of removed scene is now newly added scene
		currentLvl = nextLevelInstance 

		set_process(false)
