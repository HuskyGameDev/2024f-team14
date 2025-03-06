extends Control


func _ready():
	
	var audio_settings = ConfigManager.load_audio()
	$"%MasterSlider".value = audio_settings.master_volume
	$"%MusicSlider".value = audio_settings.music_volume
	$"%SFXSlider".value = audio_settings.sfx_volume
	
	ConfigManager.configLoaded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Closes settingsMenu if "MENU" is pressed
	if Input.is_action_just_pressed("Escape"):
		_on_exit_button_pressed()

# Closes settingsMenu if exit button is pressed
func _on_exit_button_pressed():
	queue_free()


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_audio("master_volume", $"%MasterSlider".value)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_audio("music_volume", $"%MusicSlider".value)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_audio("sfx_volume", $"%SFXSlider".value)


func _on_dialogue_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_audio("dialogue_volume", $"%DialogueSlider".value)


func _on_text_spd_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_gameplay("text_speed", $"%TextSpdSlider".value)

func _on_crt_effect_check_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigManager.save_gameplay("crt_effect", $"%CRTEffectSlider".value)
