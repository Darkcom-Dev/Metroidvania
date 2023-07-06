extends Area2D

@export var scene_from_disk : String


func _ready():
	if scene_from_disk == '':
		print('Asigne la escena actual desde el disco')

func _on_body_entered(body):
	# TODO: Crear un sonido para el checkpoint
	if body.is_in_group('player') and not GAME_MANAGER.is_loaded_from_disk:
		
		GAME_MANAGER.location.last_checkpoint = global_position
		if scene_from_disk != '':
			GAME_MANAGER.location.checkpoint_scene = scene_from_disk
			GAME_MANAGER.save_data()
			$coin_audio.play()
			$anim_checkpoint.play("Turn")
			set_collision_mask_value(2,false)
			print('Partida guradada')
		else:
			print('Asigne la escena actual desde el disco')
			print('Ha fallado el guardado')	
		
		
