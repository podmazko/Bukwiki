extends Control

@onready var PopupNode:TextureRect=$Character
@onready var TextNode:Label=$Character/Bubble


func _ready() -> void:
	PopupNode.scale=Vector2(0,0)
	PopupNode.pivot_offset=PopupNode.size
	Globals.ShowMessage.connect(message)
	Globals.HideMessage.connect(hide_message)
	get_viewport().size_changed.connect(_replace_on_screen)

###### Inner Funtions
var _popup_scale:=Vector2(0.9,0.9)
func message(_text:String,img:String="",from_scale:=Vector2(1.03,0.98))->void:
	if _text.left(1)=="_": #text code
		match _text:
			"_wrong":
				var _info:Array=wrong_answer()
				_text=_info[0]
				img=_info[1]
			"_right":
				var _info:Array=right_answer()
				_text=_info[0]
				img=_info[1]
	
	PopupNode.scale=from_scale*_popup_scale
	TextNode.text=_text
	PopupNode.texture=load("res://Assets/Images/Popup/"+img+".png")
	PopupNode.size=Vector2(0,0)
	TextNode.size.x=0
	_replace_on_screen()
	
	PopupNode.pivot_offset=PopupNode.size
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(PopupNode,"scale",_popup_scale,0.6)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(PopupNode,"modulate:a",1.0,0.2)

func _replace_on_screen()->void:
	PopupNode.position=get_viewport_rect().size-PopupNode.size
	
	TextNode.position.x=120-TextNode.size.x
	

var V_message_n:int=0
var X_message_n:int=0
func wrong_answer():
	var _t:String=["Ой! Что-то не то...","Ух, не подошло"][X_message_n]
	X_message_n+=1
	if X_message_n==2:
		X_message_n=0
	return [_t,"Fear"] #[text,image name]

func right_answer():
	var _t:String=["Ого, ты молодец!","Правильно!","Умничка!","Верно!","Супер!"][V_message_n]
	V_message_n+=1
	if V_message_n==5:
		V_message_n=0
	return [_t,"Happy"] #[text,image name]


func hide_message()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(PopupNode,"modulate:a",0,1.0)
