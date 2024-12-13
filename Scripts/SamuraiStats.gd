extends Control

@export var click_sound: AudioStream 

func _on_back_button_pressed():
	if click_sound:  # Se è stato assegnato un suono
		play_sound_and_execute(click_sound, func() -> void:
			get_tree().change_scene_to_file("res://Scenes/SelectCharacter.tscn"))
	else:
		get_tree().change_scene_to_file("res://Scenes/SelectCharacter.tscn")
	pass 

func play_sound_and_execute(sound: AudioStream, action: Callable):
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)  # Aggiungi l'AudioStreamPlayer come figlio temporaneo
	audio_player.stream = sound
	audio_player.play()

	# Usa un Timer per aspettare la fine del suono
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = audio_player.stream.get_length()
	timer.connect("timeout", Callable(self, "_on_sound_finished").bind(audio_player, action))
	add_child(timer)
	timer.start()

# Funzione chiamata dopo che il suono è finito
func _on_sound_finished(audio_player: AudioStreamPlayer, action: Callable):
	audio_player.queue_free()  # Rimuovi il player
	action.call()  # Esegui l'azione passata come parametro
