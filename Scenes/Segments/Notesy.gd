extends Control

var _NotesNode:PackedScene=preload("res://Scenes/Parts/Notes.tscn")
@onready var Center:Control=$Center

var message:=[]

var LevelCounter:int
func _init_segment(_segment_info_words:Array)->void: #[(2, 2), 0.3]
	var _grid:Vector2=_segment_info_words[0]
	var _words:Array=_segment_info_words[1]
	message=_segment_info_words[2]
	
	var _words_count:int=_grid.x*_grid.y
	LevelCounter=_words_count
	
	#Init notes
	var base_size:Vector2=Vector2(526,448) #base notes size
	var _offset:Vector2=Vector2(20,20)
	var _axis:Vector2=Vector2(0,0)  #_grid
	var _start_point:Vector2
	_start_point.x=-0.5*(_grid.x*base_size.x+_offset.x*(_grid.x-1))
	_start_point.y=-0.5*(_grid.y*base_size.y+_offset.y*(_grid.y-1))
	
	for _word in _words:
		var _inst:Control=_NotesNode.instantiate()
		Center.add_child(_inst)

		_inst.position=_start_point+_axis*(base_size+_offset)
		_inst.modulate.a=0
		
		_inst._init_notes(_word,self)
		
		_axis.x+=1
		if _axis.x==_grid.x:
			_axis.x=0
			_axis.y+=1
	
	#fied is too big > scale it
	if _start_point.x<-800:
		var _f:float=-800/_start_point.x
		Center.scale=Vector2(_f,_f)
	

func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	
	if message.size()>0:
		_tween.tween_callback(Globals.emit_signal.bind("ShowMessage",message[1],message[0],Vector2(0.5,0)) )\
				.set_delay(1)

	var _delay:=0.0
	for _word in Center.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.7,0.7))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.15
		

func check_level()->void:
	LevelCounter-=1
	if LevelCounter==0:
		var _tween:Tween=create_tween()
		_tween.tween_callback(finish_level).set_delay(1.0)

func finish_level()->void:
	Globals.emit_signal("HideMessage")
	var _tween:Tween=create_tween().set_parallel(true)
	
	var _delay:=0.0
	for _word in Center.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.85,0.85))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.15

	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.3)

	#main scene will call disappear anim after that

func disappear_anim()->void:
	queue_free()
