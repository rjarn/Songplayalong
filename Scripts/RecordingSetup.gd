extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var muteButtonBoolean = false

var isRecording = false

# docs for recording audio below 
# https://docs.godotengine.org/en/stable/tutorials/audio/recording_with_microphone.html
var idx
var effect

# placeholder for retrieved recorded audio
var recording

# change file name easily for testing
var booleanFileName = false

# file path for recording audio file destinations
var path

var optionButtonInputDevices
# the below vbox will be invisible until a recording is finished
# and will be potentially saved after given a file name.
var vboxContainerSavePrompt

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assign OptionButton to a smaller length name so the code doesnt look as big.
	optionButtonInputDevices = $VBoxContainer/HBoxContainer/OptionButtonInputDevices
	
	# will be visible when saving a recording
	vboxContainerSavePrompt = $VBoxContainerSavePrompt
	vboxContainerSavePrompt.visible = false
	
	# populate OptionButton with all detected audio input devices.
	for i in AudioServer.capture_get_device_list().size():
		optionButtonInputDevices.add_item(AudioServer.capture_get_device_list()[i])
		pass
	
	#populate second OptionButton with user created backing track audio files.
	populateOptionButtonWithAudioFiles()
	
	# We get the index of the "Record" bus.
	idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)
	
	# Why does the audio bus not let you put the dB value to 0?
	# Or at the very least change it by typing in a value.
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionButtonInputDevices_item_selected(index):
	AudioServer.capture_device = AudioServer.capture_get_device_list()[index]
	pass # Replace with function body.


func _on_ButtonMuteInputAudio_pressed():
	
	#
	# TODO test if you can mute the bus
	# but still record the audio input at the same time
	#
	# *** audio still gets recorded even though the bus is muted ***
	# *** at least with this implementation? who knows ***
	
	
	muteButtonBoolean = !muteButtonBoolean
	
	if muteButtonBoolean:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		$VBoxContainer/HBoxContainer/ButtonMuteInputAudio.text = "Unmute"
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		$VBoxContainer/HBoxContainer/ButtonMuteInputAudio.text = "Mute"
	
	pass # Replace with function body.


func _on_ButtonChangeScene_pressed():
	get_tree().change_scene("res://Scenes/Home.tscn")
	pass # Replace with function body.


func _on_ButtonRecord_pressed():
	isRecording = !isRecording
	
	if isRecording:
		#Recording begins
		effect.set_recording_active(true)
		$VBoxContainer/HBoxContainer/ButtonRecord.text = "Stop Recording"
		$AudioStreamPlayerBackingTrack.play()
		pass
	else:
		recording = effect.get_recording()
		
		effect.set_recording_active(false)
		
		$VBoxContainer.visible = false
		vboxContainerSavePrompt.visible = true
		#if booleanFileName:
			#recording.save_to_wav("Recordings/test1.wav")
		#else:
			#recording.save_to_wav("Recordings/test2.wav")
		
		#$VBoxContainer/HBoxContainer/ButtonRecord.text = "Begin Recording"
		#get_tree().reload_current_scene()
		pass
	
	pass # Replace with function body.


func populateOptionButtonWithAudioFiles():
	var files = []
	var dir = Directory.new()
	dir.open("res://Recordings/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			$VBoxContainer/HBoxContainer2/OptionButtonBackingTrack.add_item(file)
			files.append(file)
	
	dir.list_dir_end()
	
	pass

func _on_OptionButtonBackingTrack_item_selected(index):
	# change second AudioStreamPlayer stream to audio file
	# to be played as a backing track when user records themselves.
	var AudioPlayerBackingTrack = $AudioStreamPlayerBackingTrack
	
	var files = []
	var dir = Directory.new()
	dir.open("res://Recordings/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	
	#if 
	AudioPlayerBackingTrack.stream = load("res://Recordings/" + files[index])
	
	pass # Replace with function body.



func _on_ButtonSaveSong_pressed():
	if $VBoxContainerSavePrompt/TextEditFileName.text.length() > 0:
		if $VBoxContainerSavePrompt/TextEditFileName.text.is_valid_filename():
			recording.save_to_wav("Recordings/" + $VBoxContainerSavePrompt/TextEditFileName.text)
			get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_ButtonDiscardSong_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
