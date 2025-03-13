extends VBoxContainer

@export var action_items: Array[String]			# Array of possible actions

@onready var control_grid_container = %CtrlGridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	load_keybindings_from_settings()
	create_action_remap_items()
	

func load_keybindings_from_settings():
	action_items.clear()
	var keybindings = ConfigManager.load_keybinding()
	for action in keybindings.keys():
		if action != "Escape":
			InputMap.action_add_event(action, keybindings[action])
			action_items.append(action)
		
	

# Creates control menu buttons and labels
func create_action_remap_items() -> void:
	var previous_item
	if control_grid_container.get_child_count() != 0:
		previous_item = control_grid_container.get_child(control_grid_container.get_child_count() - 1)
	
	# For each action in action_items
	var range1 = action_items.size()
	if FileAccess.file_exists("settings.ini"):
		range1 -= 1
	
	for i in range(range1):
		var action = action_items[i]    
		var label = Label.new()
		
		# Sets and adds label text
		label.text = action
		label.theme_type_variation = "Label"
		control_grid_container.add_child(label)
		
		# Adds RemapButton 
		var button = RemapButton.new()
		button.action = action
		if(i != 0):
			button.focus_neighbor_top = previous_item.get_path()
			#previous_item.focus_neighbor_bottom = button.get_path()
		previous_item = button
		
		control_grid_container.add_child(button)


func _on_reset_controls_pressed() -> void:
	for x in control_grid_container.get_children():
		control_grid_container.remove_child(x)
	InputMap.load_from_project_settings()
	
	var config = ConfigManager.config
	config.set_value("keybinding", "move_forwards", "W")
	config.set_value("keybinding", "turn_left", "A")
	config.set_value("keybinding", "move_backwards", "S")
	config.set_value("keybinding", "turn_right", "D")
	config.set_value("keybinding", "P", "P")
	config.set_value("keybinding", "attack_or_shoot", "mouse_1")
	config.set_value("keybinding", "reload", "R")
	config.set_value("keybinding", "G", "G")
	config.set_value("keybinding", "aim", "mouse_2")
	config.set_value("keybinding", "Target", "mouse_3")
	config.set_value("keybinding", "Interact", "E")
	config.set_value("keybinding", "Sprint", "Shift")
	config.set_value("keybinding", "TurnAround", "C")
	config.set_value("keybinding", "Melee", "V")
	
	ConfigManager.save_config()
	ConfigManager.load_config()
	
	load_keybindings_from_settings()
	create_action_remap_items()
	
	
	
