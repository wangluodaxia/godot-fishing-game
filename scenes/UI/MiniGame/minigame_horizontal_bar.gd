extends Control
class_name MinigameHorizontal


@onready var cursor = $AspectRatioContainer/FishingGameCursor
@onready var cursor_area = $AspectRatioContainer/FishingGameCursor/Area2D
@onready var bar_container = $AspectRatioContainer/FishingGameUi
@onready var bars :Node2D = $AspectRatioContainer/Bars
@onready var left_border = $AspectRatioContainer/LeftBoundary
@onready var right_border = $AspectRatioContainer/RightBoundary

@onready var minigame_sm = $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var moving_bar_state = $MovingBarState
@onready var moving_cursor_state = $MovingCursorState
@onready var moving_dots_state = $MovingDotsState
@onready var animated_bar_state = $AnimatedBarState


var catchable :CatchableRes = null

var mouse_sensitivity = 500
var bar_container_offset_top = 100
var bar_container_lateral_offset :float = 60
var min_cursor_pos
var max_cursor_pos

var width
var height
var bar_container_width
var is_cursor_inside_area :bool = false
var areas_cursor_is_in :Array = []


func _ready() -> void:
	width = size.x
	height = size.y
	bar_container_width = bar_container.texture.get_width() * bar_container.scale.x
	
	bar_container_offset_top *= bar_container.scale.x
	bar_container_lateral_offset *= bar_container.scale.x
	
	bar_container.global_position = Vector2(width / 2, (height / 2) + bar_container_offset_top)
	cursor.global_position = Vector2(width / 2, (height / 2) + bar_container_offset_top)
	
	min_cursor_pos = (width / 2) - (bar_container_width / 2) + bar_container_lateral_offset
	max_cursor_pos = (width / 2) + (bar_container_width / 2) - bar_container_lateral_offset


func _remove_bars():
	for child in bars.get_children():
		bars.remove_child(child)


func init(init_catchable :CatchableRes):
	self.catchable = init_catchable
	
	_remove_bars()
	
	if catchable.minigame_res != null:
		minigame_sm.set_current_state(animated_bar_state)
		return
	
	if catchable.tags.has(CatchableRes.ELureTag.MULTIPLE_LEGS):
		minigame_sm.set_current_state(moving_dots_state)
	elif catchable.category.tag == CategoryRes.ELureCategory.FISH:
		minigame_sm.set_current_state(moving_bar_state)
	else:
		minigame_sm.set_current_state(moving_cursor_state)


func _input(event: InputEvent) -> void:
	minigame_sm.current_state.on_input(event)


func _on_area_2d_area_entered(area):
	is_cursor_inside_area = true
	areas_cursor_is_in.append(area)


func _on_area_2d_area_exited(area):
	var idx := areas_cursor_is_in.find(area)
	areas_cursor_is_in.remove_at(idx)
	if areas_cursor_is_in.is_empty():
		is_cursor_inside_area = false
