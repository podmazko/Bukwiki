extends Control

@onready var LabelNode:Label=$Label
@onready var Hbox:HBoxContainer=$HBox
@onready var Cards:Array=[$"HBox/1", $"HBox/2", $"HBox/3"]

var _steps:Array
var _cur_step:int=0

var RightAnswer:int
func _init_segment(_segment_info_words:Array)->void: #[(2, 2), 0.3]
	_block_cards(true)
	_steps=_segment_info_words
	
	for _inst in Cards:
			_inst.mouse_entered.connect(Globals._hover_image.bind(_inst))
			_inst.mouse_exited.connect(Globals._hover_image_exit)
			_inst.gui_input.connect(object_input.bind(_inst))

func appear_anim()->void:
	try_to_set_next_quizz()

func try_to_set_next_quizz()->void:
	if _steps.size()==_cur_step:
		finish_level()
		return
	
	_block_cards(false)
	#func set next step
	Globals.emit_signal("SFX","A")
	var _step_info=_steps[_cur_step]
	
	LabelNode.text=_step_info[0]
	LabelNode.size=Vector2(0,0)
	RightAnswer=_step_info[2]
	
	for i in 3:
		Cards[i]._init_memory_card(_step_info[1][i])
		Cards[i].swap()
		Cards[i]._prepare_to_quiz_segment()
		
	var _tween:Tween=create_tween()
	_tween.tween_property(LabelNode,"modulate",Color(1,1,1,1.0),1.3).from(Color(1.3,1.3,1.3,0.0))


var _offset:=70 #(285+15=300)
func _physics_process(delta: float) -> void:#Flow placing
	var _start_y:float=-0.5*(LabelNode.size.y+300)
	
	LabelNode.position.y=lerp(LabelNode.position.y,_start_y,delta*3)
	Hbox.position.y=lerp(Hbox.position.y,_start_y+LabelNode.size.y+_offset,delta*3)

func _block_cards(_bool:bool)->void:
	for _c in Cards:
		_c.mouse_filter=0+int(_bool)*2
	
	
func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		var _tween:Tween=create_tween().set_parallel(true)
		
		var _pressed_n:int=Cards.find(object)
		if _pressed_n==RightAnswer: #right answer
			_block_cards(true)
			_cur_step+=1
			Globals.emit_signal("SFX","A")
			for _c in Cards: #close another cards
				if _c!=object:
					_c.swap(true)
			_tween.tween_callback(object.swap.bind(true)).set_delay(1.0)
			_tween.tween_property(object,"scale",Vector2(1,1),0.8).from(Vector2(1.2,1.2))\
							.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			_tween.tween_property(object,"modulate",Color(1,1,1,1.0),0.8).from(Color(1.3,1.3,1.3,1.0))
			_tween.tween_callback(try_to_set_next_quizz).set_delay(2.0)
		else:
			Globals.emit_signal("SFX","C")
			#wrong anim
			_tween.tween_property(object,"rotation_degrees",0,0.6).from(-15)\
					.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			_tween.tween_property(object,"modulate",Color(1,1,1,1.0),0.5).from(Color(1.5,1.1,1.0,1.0))
		
		
func finish_level()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	var _delay:=0.0
	for _c in Cards:
		_tween.tween_property(_c,"modulate:a",0,0.5).set_delay(_delay)
		_delay+=0.33
#
	_tween.tween_property(self,"modulate:a",0,1.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(1.0)
	#main scene will call disappear anim after that


func disappear_anim()->void:
	queue_free()
