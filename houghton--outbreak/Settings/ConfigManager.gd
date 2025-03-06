extends Node


var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "setting.ini"

var configLoaded = false

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "move_forwards", "W")
		config.set_value("keybinding", "turn_left", "A")
		config.set_value("keybinding", "move_backwards", "S")
		config.set_value("keybinding", "turn_right", "D")
		config.set_value("keybinding", "P", "P")
		config.set_value("keybinding", "attack_or_shoot", "Left Mouse Button")
		config.set_value("keybinding", "reload", "R")
		config.set_value("keybinding", "G", "G")
		config.set_value("keybinding", "aim", "Right Mouse Button")
		config.set_value("keybinding", "Target", "Middle Mouse Button")
		config.set_value("keybinding", "Interact", "E")
		config.set_value("keybinding", "Sprint", "Shift")
		config.set_value("keybinding", "TurnAround", "C")
		config.set_value("keybinding", "Melee", "V")
		
		config.set_value("audio", "master_volume", 0.5)
		config.set_value("audio", "music_volume", 0.5)
		config.set_value("audio", "sfx_volume", 0.5)
		
		config.save(SETTINGS_FILE_PATH)
		
	else:
		config.load(SETTINGS_FILE_PATH)
		


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


func save_gameplay(key: String, value):
	config.set_value("gameplay", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_gameplay():
	var gameplay_settings = {}
	for key in config.get_section_keys("gameplay"):
		gameplay_settings[key] = config.get_value("gameplay", key)
	return gameplay_settings
