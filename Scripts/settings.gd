extends Node

const SAVE_PATH = "user://config.cfg"
const ALWAYS_TRUE = true

var configFile = ConfigFile.new()

# THESE ARE DEFAULT SETTINGS
var settings = {
	# Names of the levels
	"levelsNames":{
		"0":"MainMenu",
		"1":"Level_1_1",
		"2":"Level_1_2",
		"3":"Level_1_3",
		"4":"Level_2_1",
		"5":"Level_2_2",
		"6":"Level_2_3"
	},
	"levelUnlocked":{
		"MainMenu": ALWAYS_TRUE,
		"Level_1_1": false,
		"Level_1_2": false,
		"Level_1_3": false,
		"Level_2_1": false,
		"Level_2_2": false,
		"Level_2_3": false
	},
	"times":{
		"Level_1_1": 0,
		"Level_1_2": 0,
		"Level_1_3": 0,
		"Level_2_1": 0,
		"Level_2_2": 0,
		"Level_2_3": 0
	},
	"lastLevel":{
		"lastLevel": "Level_1_1"
	},
	"options":{
		"volume": "on",
		"movement": "swipe"
	}
}

func _ready():
	#pass
	#loadSettings()
	#saveDefaultSettings()
	print(loadSetting("options", "volume"))
	
	
# USE TO RESTORE DEFAULT VALUES
func saveDefaultSettings():
	for section in settings.keys():
		for key in settings[section]:
			configFile.set_value(section, key, settings[section][key])
			
	configFile.save(SAVE_PATH)


func saveSetting(section, key, value):
	configFile.set_value(section, key, value)
	configFile.save(SAVE_PATH)

func loadSettings():
	var error = configFile.load(SAVE_PATH)
	if error != OK:
		print("Failed loading settings file. Error code is: ", error)
		return []
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = configFile.get_value(section, key, null)


func loadSetting(section:String, key:String) -> String:
	var error = configFile.load(SAVE_PATH)
	if error != OK:
		#print("Failed loading settings file. Error code is: "% error)
		print("Failed loading settings file. Error code is: ", error)
		return ""
		
	return configFile.get_value(section, key, null)
