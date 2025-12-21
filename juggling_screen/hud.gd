extends Control
class_name HUD

const HEART_EMPTY = preload("uid://c8p21m7n1ohrc")

@onready var score_label: Label = $Score
@onready var hearts = [$HealthContainer/Heart1, $HealthContainer/Heart2, $HealthContainer/Heart3]

var score_tween: Tween = null
var score: int = 0 : set = set_score
var target_score = 0

var health := 3 : set = set_health

func update_score(value: int) -> void:
	#score = target_score
	score_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	score_tween.tween_property(self, "score", value, 0.5)

func set_score(value: int) -> void:
	score = value
	score_label.text = "Score: " + str(value)

func set_health(value: int) -> void:
	health = value
	hearts[health].texture = HEART_EMPTY
