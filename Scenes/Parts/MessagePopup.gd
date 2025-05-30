extends Control

@onready var PopupNode:HBoxContainer=$HBox


func _ready() -> void:
	PopupNode.scale=Vector2(0,0)
	PopupNode.pivot_offset=PopupNode.size
	PlayerData.ShowMessage.connect(message)
	PlayerData.HideMessage.connect(hide_message)

###### Inner Funtions
var _popup_scale:=Vector2(0.9,0.9)
func message(_text:String,img:String,from_scale:=Vector2(1.03,0.98))->void:
	PopupNode.scale=from_scale*_popup_scale
	$HBox/Bubble.text=_text+"\n"
	$HBox/Character.texture=load("res://Assets/Images/Popup/"+img+".png")
	
	PopupNode.pivot_offset=PopupNode.size
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(PopupNode,"scale",_popup_scale,0.6)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(PopupNode,"modulate:a",1.0,0.2)

func hide_message()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(PopupNode,"modulate:a",0,1.0)
