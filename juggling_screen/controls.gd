extends VBoxContainer

const ARROW_LEFT_KEY_DARK = preload("uid://dm3mw62xxrlkm")
const ARROW_RIGHT_KEY_DARK = preload("uid://cescgydrw2cgp")
const ARROW_UP_KEY_DARK = preload("uid://djwkestb1fkoo")
const XBOX_SERIES_X_A = preload("uid://bi06qps2kcmr5")
const XBOX_SERIES_X_DPAD_LEFT = preload("uid://df580onjw74aq")
const XBOX_SERIES_X_DPAD_RIGHT = preload("uid://c3ahksrkdl1g7")
const XBOX_SERIES_X_LB = preload("uid://cu7wvs00iodht")
const XBOX_SERIES_X_RB = preload("uid://ces5fr171hm2u")

@onready var shift_left: HBoxContainer = $ShiftLeft
@onready var shift_right: HBoxContainer = $ShiftRight
@onready var far_left: HBoxContainer = $FarLeft
@onready var far_right: HBoxContainer = $FarRight
@onready var strike: HBoxContainer = $Strike

var controller = true : set = set_controller

func _ready() -> void:
	controller = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		controller = false;
	if event is InputEventJoypadButton:
		controller = true;

func set_controller(value: bool) -> void:
	controller = value
	if controller:
		shift_left.get_node("TextureRect").texture = XBOX_SERIES_X_DPAD_LEFT
		shift_right.get_node("TextureRect").texture = XBOX_SERIES_X_DPAD_RIGHT
		far_left.show()
		far_right.show()
		strike.get_node("TextureRect").texture = XBOX_SERIES_X_A
	else:
		shift_left.get_node("TextureRect").texture = ARROW_LEFT_KEY_DARK
		shift_right.get_node("TextureRect").texture = ARROW_RIGHT_KEY_DARK
		far_left.hide()
		far_right.hide()
		strike.get_node("TextureRect").texture = ARROW_UP_KEY_DARK
