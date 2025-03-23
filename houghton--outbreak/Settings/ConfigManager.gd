extends Node

var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "setting.ini"

var configLoaded = false

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "Move Forward", "W")
		config.set_value("keybinding", "Turn Left", "A")
		config.set_value("keybinding", "Move Backward", "S")
		config.set_value("keybinding", "Turn Right", "D")
		config.set_value("keybinding", "Sprint", "Shift")
		config.set_value("keybinding", "Turn Around", "C")
		config.set_value("keybinding", "Interact", "E")
		config.set_value("keybinding", "Primary Fire", "mouse_1")
		config.set_value("keybinding", "Secondary Fire (Aim)", "mouse_2")
		config.set_value("keybinding", "Target", "mouse_3")
		config.set_value("keybinding", "Reload", "R")
		config.set_value("keybinding", "Inventory", "P")
		
		config.set_value("audio", "master_volume", 0.5)
		config.set_value("audio", "music_volume", 0.5)
		config.set_value("audio", "sfx_volume", 0.5)
		
		config.save(SETTINGS_FILE_PATH)
		
	else:
		config.load(SETTINGS_FILE_PATH)
	
	load_keybindings_from_settings()
	load_audio_from_settings()
	


func save_keybinding(action: StringName, event : InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	if action != "ESCAPE":
		config.set_value("keybinding", action, event_str)
		config.save(SETTINGS_FILE_PATH)


func load_keybinding():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	
	for key in keys:
		var input_event 
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	
	return keybindings


func save_audio(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_audio():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings


func load_keybindings_from_settings():
	var keybindings = load_keybinding()
	for action in keybindings.keys():
		if action != "Escape":
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, keybindings[action])

func load_audio_from_settings():
	var audio_settings = load_audio()
	AudioServer.set_bus_volume_db(MASTER_BUS_ID,linear_to_db(audio_settings.master_volume))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(audio_settings.music_volume))
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(audio_settings.sfx_volume))
	

func save_config():
	config.save(SETTINGS_FILE_PATH)

func load_config():
	config.load(SETTINGS_FILE_PATH)
