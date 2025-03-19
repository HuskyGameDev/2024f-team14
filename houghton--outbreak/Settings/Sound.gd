extends Control


@onready var masterStream = preload("res://Audio/Online Sources/Zombie Death.wav")
@onready var musicStream = preload("res://Audio/Online Sources/Food Crunch.wav")
@onready var sfxStream = preload("res://Audio/Gunshot SFX.wav")

@onready var AudioTest = get_tree().get_first_node_in_group("Audio")

var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var playSound = false

func _ready():
	
	var audio_settings = ConfigManager.load_audio()
	$"%MasterSlider".value = audio_settings.master_volume
	$"%MusicSlider".value = audio_settings.music_volume
	$"%SFXSlider".value = audio_settings.sfx_volume
	
	AudioServer.set_bus_volume_db(MASTER_BUS_ID,linear_to_db(audio_settings.master_volume))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(audio_settings.music_volume))
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(audio_settings.sfx_volume))
	
	playSound = true



func _on_reset_sound_pressed() -> void:
	playSound = false
	$%MasterSlider.value = 0.5
	$%MusicSlider.value = 0.5
	$%SFXSlider.value = 0.5
	ConfigManager.save_audio("master_volume", $"%MasterSlider".value)
	ConfigManager.save_audio("music_volume", $"%MusicSlider".value)
	ConfigManager.save_audio("sfx_volume", $"%SFXSlider".value)
	playSound = true


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS_ID,linear_to_db(value))
	ConfigManager.save_audio("master_volume", $"%MasterSlider".value)
	play_audio(masterStream, "Master")


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(value))
	ConfigManager.save_audio("music_volume", $"%MusicSlider".value)
	play_audio(musicStream, "Music")


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(value))
	ConfigManager.save_audio("sfx_volume", $"%SFXSlider".value)
	play_audio(sfxStream, "SFX")



func play_audio(audio, bus):
	if playSound:
		var new_audio_player = AudioTest.duplicate()
		new_audio_player.stream = audio
		new_audio_player.bus = bus
		get_tree().root.add_child(new_audio_player)
		new_audio_player.play()
		await new_audio_player.finished
		new_audio_player.queue_free()
