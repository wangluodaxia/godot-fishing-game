extends Node3D
class_name AnimatedFish


@onready var animation_player := $fish/AnimationPlayer

@export var catchable :CatchableRes
@export var animation_name :String


func _ready() -> void:
	pass
	#animation_player.animation_finished.connect(_on_animation_finished)


func play_animation():
	animation_player.play(animation_name)


func _on_animation_finished(anim_name :String) -> void:
	print(anim_name)
	animation_player.animation_finished.disconnect(_on_animation_finished)
	queue_free()
