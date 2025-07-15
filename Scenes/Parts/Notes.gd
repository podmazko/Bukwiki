extends TextureRect


var Parent:Control

@onready var _Labels:Array=[$"Words/1", $"Words/2", $"Words/3"]
var right_answer_node:Label

func _init_notes(_word:String,_prnt:Control)->void:
	_base_pos=position
	$Icon.texture=load("res://Assets/Images/Objects/"+Data.Words[_word][0]+".png")
	Parent=_prnt
	
	var _right_n:int=_word.length()-4
	
	var _left_size:String=_word.left(-3-_right_n)
	var _right_size:String=_word.right(_right_n)
	var _p3=_word.right(1+_right_n).left(1)
	var _p2=_word.right(2+_right_n).left(1)
	var _p1=_word.right(3+_right_n).left(1)
	var _variants:=[_left_size+_p1+_p2+_p3+_right_size,_left_size+_p2+_p3+_p1+_right_size,_left_size+_p3+_p1+_p2+_right_size]
	
	_Labels.shuffle()
	right_answer_node=_Labels[0]
	for i in 3:
		var _label:Label=_Labels[i]
		_label.text=_variants[i]
		_label.mouse_filter=0
		_label.gui_input.connect(word_check.bind(_label))
		_label.mouse_entered.connect(Globals._hover_image.bind(_label))
		_label.mouse_exited.connect(Globals._hover_image_exit)
		_label.pivot_offset=_label.size*Vector2(0.5,0.5)
	

var _base_pos:Vector2
func word_check(event:InputEvent,_label:Label)->void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var _tween:Tween=create_tween().set_parallel(true)
			if _label!=right_answer_node: #wrong answer
				Globals.emit_signal("ShowMessage","_wrong")
				_tween.tween_property(_label,"rotation_degrees",0,0.6).from(-15)\
						.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
				_tween.tween_property(_label,"modulate",Color(1,1,1,1.0),0.5).from(Color(1.5,1.0,1.0,1.0))
				_tween.tween_property(self,"modulate",Color(1,1,1,1.0),0.5).from(Color(1.5,1.0,1.0,1.0))
				Globals.emit_signal("SFX","C")
			else:
				Globals.emit_signal("ShowMessage","_right")
				Globals.emit_signal("SFX","A")
				
				_tween.tween_property(self,"position:y",self.position.y,0.7).from(_base_pos.y-40)\
					.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
				_tween.tween_property(self,"scale",Vector2(1,1),0.8).from(Vector2(1.02,1.06))\
					.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)						
				_tween.tween_property(self,"rotation_degrees",0,0.9).from(-3)\
						.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
				
				for i in _Labels:
					i.mouse_filter=2
					if i!=right_answer_node:
						_tween.tween_property(i,"modulate",Color(0.7,0.7,0.7,0.3),0.5)
					else:
						_tween.tween_property(i,"modulate",Color(1.2,1.2,1.2,1.0),0.5)
				
				_tween.tween_property(self,"modulate",Color(0.95,0.95,0.95,0.7),0.5)
				Parent.check_level()
