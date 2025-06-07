extends Control

@onready var LevelButton:PackedScene=preload("res://Scenes/Parts/LevelButton.tscn")


@onready var LevelLabel:Label = $LevelLabel

@onready var button_play = $BgColor/Menu/Buttons/Play
@onready var button_play_online = $BgColor/Menu/Buttons/PlayOnline
@onready var button_exit = $BgColor/Menu/Buttons/Exit

@onready var menu_ = $BgColor/Menu
@onready var menu_buttons = $BgColor/Menu/Buttons
@onready var menu_char = $BgColor/Menu/CharA
@onready var levels_buttons= $BgColor/Menu/CharA/LevelsPositions

var base_params:=[]

var SFXplayback:AudioStreamPlaybackPolyphonic

func _ready():
	Blocker.visible=false
	LevelLabel.modulate.a=0.0
	button_play.pressed.connect(_on_play_pressed)
	button_play_online.pressed.connect(_on_play_online_pressed)
	button_exit.pressed.connect(_on_exit_pressed)
	Globals.NextSegment.connect(next_segment)
	
	var _lvl_label:Label=$BgColor/Menu/CharA/Label
	_lvl_label.pivot_offset=_lvl_label.size*Vector2(0.5,0.5)
	_lvl_label.scale=Vector2(0.5,0.0)
	
	base_params.append(menu_buttons.position.x)
	base_params.append(menu_char.position.x)
	_setup_levels_buttons()
	
	#set SFX
	$SFX.play()
	SFXplayback=$SFX.get_stream_playback()
	Globals.SFX.connect(SFX)
	
	
func SFX(_type:String)->void:
	call("_playSFX_"+_type)
func _playSFX_A()->void:
	SFXplayback.play_stream(preload("res://Assets/SFX/impactMining_000.ogg"), 0, -5, randf_range(0.9, 1.1))
func _playSFX_B()->void:
	SFXplayback.play_stream(preload("res://Assets/SFX/impactTin_medium_003.ogg"), 0, -10, randf_range(0.9, 1.1))
func _playSFX_C()->void:
	SFXplayback.play_stream(preload("res://Assets/SFX/SFX-Sparks.ogg"), 0, -10, randf_range(0.9, 1.1))
func _playSFX_D()->void:
	SFXplayback.play_stream(preload("res://Assets/SFX/SFX-Liquid-09-Bubbles.ogg"), 0, 0, randf_range(0.9, 1.1))
	
	
	
func _setup_levels_buttons()->void:
	for i in Data.LevelsInfo:
		var _ints:Button=LevelButton.instantiate()
		levels_buttons.add_child(_ints)
		var _row:int=int((i-1)/5)
		_ints.text=str(i)
		_ints.position.x=(i-_row*5)*280
		_ints.position.y=340*_row
		
		_ints.pressed.connect(start_level.bind(i))
		
		
		if i==(PlayerData.LevelsCompleted+1):
			_ints.set_status(1)
		elif i>(PlayerData.LevelsCompleted+1):
			_ints.set_status(2)
	levels_buttons.visible=false
	


func _on_play_pressed(): #show level choosing UI
	for _b in menu_buttons.get_children():
		if _b is Button:
			_b.disabled=true
	_UI_blocker(2.0)
	Globals.emit_signal("SFX","B")
	
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(menu_buttons, "position:x", base_params[0]+2000, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(menu_buttons, "modulate:a", 0.0, 0.05).set_delay(0.2)
	_tween.tween_property(menu_char, "position:x", base_params[0]+100, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(menu_char, "position:y", 400, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(menu_char, "scale", Vector2(0.8,0.8), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	#choose level label
	_tween.tween_property($BgColor/Menu/CharA/Label, "scale", Vector2(1,1), 1.0).set_delay(1.2)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(1.2)
	
	#level buttons appearing
	var _offset:=0.3
	var _buttons:Array=levels_buttons.get_children()
	for _button_n in levels_buttons.get_child_count():
		var _button:Button=_buttons[_button_n]
		var _row:int=int((_button_n-1)/5)
		#_button.modulate.a=0.0
		_button.scale=Vector2(0.0,0.0)
		_tween.tween_property(_button, "scale", Vector2(1,1), 1.3).set_delay(_offset-_row*0.4).\
							set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		_offset+=0.1
	
	levels_buttons.visible=true

var _level_started:=false
func start_level(_level_n:int)->void:
	Globals.emit_signal("SFX","B")
	if _level_started: #bugs with clicking on level buttons
		return
	_level_started=true
	Globals.current_level_in_play=_level_n

	#block inputs
	_UI_blocker(3.0)
	
	#hide level menu
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(menu_char, "position:y", menu_char.position.y+200, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(menu_char, "position:x", menu_char.position.x+100, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(menu_char, "rotation_degrees", 10, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(menu_char, "modulate:a", 0.0, 0.5)
	_tween.tween_callback(menu_.set.bind("visible",false)).set_delay(0.5)
	
	var _level_info:Array=Data.LevelsInfo[Globals.current_level_in_play]
	
	level_flow_data=_level_info[1].duplicate()
	_tween.tween_callback(next_segment).set_delay(3.5)
	
	#screen change animation
	LevelLabel.modulate.a=0.00
	LevelLabel.text="День "+str(Globals.current_level_in_play)+"\n"+_level_info[0]
	_tween.tween_property(LevelLabel, "modulate:a", 1.0, 1.0)
	_tween.tween_property(LevelLabel, "modulate:r", 1.25, 1.5)
	_tween.tween_property(LevelLabel, "modulate:g", 1.25, 1.5)
	_tween.tween_property(LevelLabel, "modulate:b", 1.25, 1.5)
	_tween.tween_property(LevelLabel, "modulate", Color(1.0,1.0,1.0,0.0), 1.6).set_delay(2.0)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

var level_flow_data:Array
var current_segment_node=null
func next_segment()->void:	
	#block inputs
	_UI_blocker(1.2)
	
	#hide prev segment
	if current_segment_node!=null: 
		Globals.current_selected=null
		current_segment_node.disappear_anim()
	
	#show next segment
	if level_flow_data.is_empty():
		_on_exit_pressed() # just for now
		on_level_finished()
		return
	
	var _current_segment:Array=level_flow_data[0].duplicate()
	level_flow_data.remove_at(0)
	
	var _inst:Control
	var _preload_info=Data.SegmentsInfo[_current_segment[0]]["preload"]
	if _preload_info is String:
		_inst=load(_preload_info).instantiate()
	else:
		_inst=_preload_info.instantiate()
	#var _inst:Control=Data.SegmentsInfo[_current_segment[0]]["preload"].instantiate()
	var _current_segment_info=Data.SegmentsInfo [_current_segment[0]] [_current_segment[1]]
	$BgColor/SegmentGrp.add_child(_inst)
	_inst._init_segment(_current_segment_info)
	
	
	current_segment_node=_inst
	
	current_segment_node.call_deferred("appear_anim")

func on_level_finished()->void:
	_level_started=false
	print("яркое окно награды за прохождение! Итоги урока")
	#hide prev segment
	current_segment_node.disappear_anim()
	current_segment_node=null
		
		
	if PlayerData.LevelsCompleted<Globals.current_level_in_play:
		PlayerData.LevelsCompleted=Globals.current_level_in_play

	#block inputs
	_UI_blocker(2.5)

	#hide level menu
	var _tween:Tween=create_tween().set_parallel(true)
	menu_char.rotation_degrees=10
	_tween.tween_property(menu_char, "position:y", menu_char.position.y-200, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(menu_char, "position:x", menu_char.position.x-100, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(menu_char, "rotation_degrees", 0, 1.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(menu_char, "modulate:a", 1.0, 0.5)
		
	print("обнови кнопки после прохождения!")
	#Globals.current_level_in_play

@onready var Blocker:Control = $Blocker
var blocker_tween:Tween
func _UI_blocker(_time:float)->void:
	if blocker_tween:
		blocker_tween.kill()
	blocker_tween=create_tween()
	blocker_tween.tween_property(Blocker, "visible", false, _time)
	Blocker.visible=true
	
	

func _on_play_online_pressed():
	print("Ищем комнату учителя...")


func _on_exit_pressed():
	print("Выход из игры...")
	get_tree().quit()
