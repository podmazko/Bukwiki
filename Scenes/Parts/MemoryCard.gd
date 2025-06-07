extends Control

@onready var sides:=[$CardFront,$CardBack]
@onready var WordLabel:Label=$Label

var cur_side:=0  #0-back     1 - front

var word:String

func _ready() -> void:
	sides[0].visible=false


func _init_memory_card(_word:String)->void:
	word=_word
	WordLabel.text=_word
	var _img_path:String=Data.Words[_word][0]
	$CardFront/Icon.texture=load("res://Assets/Images/Objects/"+_img_path+".png")

func swap()->void:
	mouse_filter=2 #block
	var _tween:Tween=create_tween()
	_tween.tween_property(self,"scale",Vector2(0,1.2),0.2)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_callback(reverse_vis)
	_tween.tween_property(self,"scale",Vector2(1.0,1.0),0.6).from(Vector2(0.7,1.2))\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(_try_to_unblock)

func _try_to_unblock()->void:
	if !word.is_empty():
		mouse_filter=0

func reverse_vis()->void:
	if cur_side==0: #back
		WordLabel.visible=true #always after first pick
		cur_side=1
		sides[0].visible=true
		sides[1].visible=false
	else:
		cur_side=0
		sides[1].visible=true
		sides[0].visible=false
