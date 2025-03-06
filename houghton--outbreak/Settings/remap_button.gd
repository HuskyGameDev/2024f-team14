extends Button
class_name RemapButton

@export var action: String

func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"
	
# Sets key text on ready
func _ready():
	load_keybindings_from_settings()
	set_process_unhandled_input(false)
	update_key_text()

func load_keybindings_from_settings():
	var keybindings = ConfigManager.load_keybinding()
	for action in keybindings.keys():
		if action != "Escape":
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, keybindings[action])

# If pressed, wait for input and release focus (so nothing else can happen until button is toggled)
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "... Awaiting Input ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		
# If button is pressed and a key is hit, swap the action in InputMap
func _unhandled_input(event):
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		ConfigManager.save_keybinding(action, event)
		button_pressed = false

# update the text on the button with the key associated with action
func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
		
	
