extends Node

@export var back_sound: AudioStream  # Suono per il pulsante Back
@export var main_menu_scene: PackedScene  # Scena del menu principale

# Funzione chiamata quando il bottone Back viene premuto


# Funzione per riprodurre il suono e poi eseguire un'azione
func play_sound_and_execute(sound: AudioStream, action: Callable):
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.play()

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = audio_player.stream.get_length()
	timer.connect("timeout", Callable(self, "_on_sound_finished").bind(audio_player, action))
	add_child(timer)
	timer.start()

# Funzione chiamata dopo che il suono è finito
func _on_sound_finished(audio_player: AudioStreamPlayer, action: Callable):
	audio_player.queue_free()
	action.call()


func _on_back_button_pressed():
	if back_sound:
		play_sound_and_execute(back_sound, func() -> void:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn"))
	else:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	pass # Replace with function body.
