extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var option

# Called when the node enters the scene tree for the first time.
func _ready():
	populateOptionButtonWithAudioFiles()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonAddAudioPlayer_pressed():
	pass # Replace with function body.


func _on_OptionButtonSelectFile1_item_selected(index):
	var AudioPlayerBackingTrack = $VBoxContainer/AudioStreamPlayer1
	
	AudioPlayerBackingTrack.stream = load("res://Recordings/" + $VBoxContainer/HBoxContainer2/VBoxContainer/OptionButtonSelectFile1.text)
	pass # Replace with function body.


func _on_ButtonDeleteAudioPlayer1_pressed():
	# nothing for now
	pass # Replace with function body.


func _on_OptionButtonSelectFile2_item_selected(index):
	var AudioPlayerBackingTrack = $VBoxContainer/AudioStreamPlayer2
	
	AudioPlayerBackingTrack.stream = load("res://Recordings/" + $VBoxContainer/HBoxContainer2/VBoxContainer2/OptionButtonSelectFile2.text)
	pass # Replace with function body.


func _on_ButtonDeleteAudioPlayer2_pressed():
	# nothing for now
	pass # Replace with function body.


func _on_ButtonMainMenu_pressed():
	get_tree().change_scene("res://Scenes/Home.tscn")
	pass # Replace with function body.

func populateOptionButtonWithAudioFiles():
	
	#$VBoxContainer/HBoxContainer2/VBoxContainer/OptionButtonSelectFile1.add_item("Select audio file here")
	#$VBoxContainer/HBoxContainer2/VBoxContainer2/OptionButtonSelectFile2.add_item("Select audio file here")
	
	var files = []
	var dir = Directory.new()
	dir.open("res://Recordings/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			$VBoxContainer/HBoxContainer2/VBoxContainer/OptionButtonSelectFile1.add_item(file)
			$VBoxContainer/HBoxContainer2/VBoxContainer2/OptionButtonSelectFile2.add_item(file)
			files.append(file)
	
	dir.list_dir_end()
	
	pass

func _on_ButtonPlayAudio_pressed():
	print($VBoxContainer/AudioStreamPlayer1.stream)
	print($VBoxContainer/AudioStreamPlayer2.stream)
	$VBoxContainer/AudioStreamPlayer1.play()
	$VBoxContainer/AudioStreamPlayer2.play()
	pass # Replace with function body.


func _on_ButtonStopAudio_pressed():
	$VBoxContainer/AudioStreamPlayer1.stop()
	$VBoxContainer/AudioStreamPlayer2.stop()
	pass # Replace with function body.
