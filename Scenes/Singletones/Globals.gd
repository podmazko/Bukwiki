extends Node

var current_level_in_play:int

signal NextSegment
signal SFX
signal ShowMessage
signal HideMessage


var current_selected=null #nullified eacg new segment
#Two types :images with color animated and buttons(just scale animation)
##type A
var _current_hover
func _hover_image(_img_node)->void:
	if _current_hover!=null:
		_hover_image_exit()
	_current_hover=_img_node
	
	if _current_hover!=current_selected:
		_img_node.modulate=Color(1.1,1.1,1.1)
		var _tween:Tween=create_tween()
		_tween.tween_property(_img_node,"scale",Vector2(1.0,1.0),0.8)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.93,0.93))


func _hover_image_exit()->void:
	if _current_hover!=null:
		if _current_hover!=current_selected:
			_current_hover.modulate=Color(1,1,1)
		_current_hover=null

##type B
func _hover_button(_button_node:Button)->void:
	if _button_node!=current_selected:
		var _tween:Tween=create_tween()
		_tween.tween_property(_button_node,"scale",Vector2(1.0,1.0),0.8)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.95,0.95))
